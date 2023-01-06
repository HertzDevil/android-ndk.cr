require "../android_ndk"
require "./configuration"
require "./log"
require "./looper"
require "./native_activity"

# The native activity interface provided by `NativeActivity` is based on a set
# of application-provided callbacks that will be called by the Activity's main
# thread when certain events occur.
#
# This means that each one of this callbacks _should_ _not_ block, or they risk
# having the system force-close the application. This programming model is
# direct, lightweight, but constraining.
#
# `NativeAppGlue` is used to provide a different execution model where the
# application can implement its own main event loop in a different thread
# instead. Here's how it works:
#
# 1. The application must provide a `NativeAppGlue::App` whose `run` method will
#    be called when the activity is created, in a new thread that is distinct
#    from the activity's main thread.
# 2. The `NativeAppGlue::App` receives a reference to a valid `NativeAppGlue`
#    that contains references to other important objects, e.g. the
#    `NativeActivity` obejct instance the application is running in.
# 3. The `NativeAppGlue` holds a `Looper` instance that already listens to two
#    important things:
#    * activity lifecycle events (e.g. "pause", "resume"). See
#      `NativeAppGlue::Command`.
#    * input events coming from the `InputQueue` attached to the activity.
#    Each of these correspond to a `Looper` identifier returned by
#    `Looper.poll_once` with values of `LOOPER_ID_MAIN` and `LOOPER_ID_INPUT`,
#    respectively.
#
#    Your application can use the same `Looper` to listen to additional
#    file-descriptors. They can either be callback based, or with return
#    identifiers starting with `LOOPER_ID_USER`.
# 4. Whenever you receive a `LOOPER_ID_MAIN` or `LOOPER_ID_INPUT` event, you can
#    call the `#process` method with the returned identifier, and override
#    `NativeAppGlue::App#on_app_cmd` and `NativeAppGlue::App#on_input_event`
#    to be called for your own processing of the event.
#
#    Alternatively, you can call the low-level functions to read and process
#    the data directly... look at the `#process` implementation in the glue to
#    see how to do this.
#
# See the sample named "native-activity" that comes with the bindings with a
# full usage example. Also look at the JavaDoc of `NativeActivity`.
class AndroidNDK::NativeAppGlue < AndroidNDK::NativeActivity::Callbacks
  enum Command : Int8
    InputChanged
    InitWindow
    TermWindow
    WindowResized
    WindowRedrawNeeded
    ContentRectChanged
    GainedFocus
    LostFocus
    ConfigChanged
    LowMemory
    Start
    Resume
    SaveState
    Pause
    Stop
    Destroy
  end

  abstract class App
    abstract def run(glue : NativeAppGlue)
    abstract def on_app_cmd(glue : NativeAppGlue, cmd : NativeAppGlue::Command)
    abstract def on_input_event(glue : NativeAppGlue, event : InputEvent) : Bool
  end

  LOOPER_ID_MAIN  = 1
  LOOPER_ID_INPUT = 2
  LOOPER_ID_USER  = 3

  class_getter! instance : NativeAppGlue

  getter activity : NativeActivity
  getter window : NativeWindow?
  getter input_queue : InputQueue?
  getter! configuration : Configuration
  getter! looper : Looper
  getter content_rect : Rect = Rect.empty

  @mutex = Thread::Mutex.new
  @cond = Thread::ConditionVariable.new

  @running = false
  @activity_state = Command::Destroy

  @state_saved = false

  @destroyed = false
  getter? destroy_requested : Bool = false

  @pending_window : NativeWindow?
  @pending_input_queue : InputQueue?

  def self.run(app : App) : Nil
    native_activity = NativeActivity.new(AndroidNDK.unsafe_native_activity)
    new(app, native_activity, AndroidNDK.unsafe_saved_state)
  end

  def initialize(@app : App, @activity : NativeActivity, @saved_state : Bytes?)
    @msg_read, @msg_write = IO::FileDescriptor.pipe(read_blocking: true, write_blocking: true)
    @thread = Thread.new(detached: true) { app_entry }
    @activity.bind_callbacks(self)

    @@instance = self

    @mutex.synchronize do
      until @running
        @cond.wait(@mutex)
      end
    end
  end

  private def app_entry
    @configuration = Configuration.new.tap &.load_from(@activity.asset_manager)
    print_cur_config

    @looper = looper = Looper.prepare(allow_non_callbacks: true)
    looper.add_fd(@msg_read.fd, Looper::Event::Input, ident: LOOPER_ID_MAIN)

    @mutex.synchronize do
      @running = true
      @cond.broadcast
    end

    begin
      @app.run(self)
    rescue ex
      Crystal::System.print_exception("Unhandled exception", ex)
    end

    free_saved_state
    @mutex.synchronize do
      @input_queue.try &.detach_looper
      @configuration = nil
      @destroyed = true
      @cond.broadcast
    end
  end

  private def free_saved_state
    @mutex.synchronize do
      if saved_state = @saved_state
        LibC.free(saved_state) unless saved_state.to_unsafe.null?
        @saved_state = nil
      end
    end
  end

  private def read_cmd
    cmd = uninitialized Int8
    if LibC.read(@msg_read.fd, pointerof(cmd), 1) != 1
      raise IO::Error.from_errno "Failure writing android_app cmd"
    end
    Command.from_value(cmd)
  end

  private def write_cmd(cmd : Command)
    if LibC.write(@msg_write.fd, pointerof(cmd), 1) != 1
      raise IO::Error.from_errno "Failure writing android_app cmd"
    end
  end

  def process(ident : Int32) : Nil
    case ident
    when LOOPER_ID_MAIN
      cmd = read_cmd
      pre_exec_cmd(cmd)
      @app.on_app_cmd(self, cmd)
      post_exec_cmd(cmd)
    when LOOPER_ID_INPUT
      input_queue = @input_queue.not_nil!
      while event = input_queue.get_event
        next if input_queue.pre_dispatch_event(event)
        handled = @app.on_input_event(self, event)
        input_queue.finish_event(event, handled)
      end
    end
  end

  def on_start : Nil
    set_activity_state(:start)
  end

  def on_resume : Nil
    set_activity_state(:resume)
  end

  def on_save_instance_state : Bytes
    @mutex.synchronize do
      @state_saved = false
      write_cmd(:save_state)
      until @state_saved
        @cond.wait(@mutex)
      end

      if saved_state = @saved_state
        @saved_state = nil
        saved_state
      else
        Bytes.new(Pointer(UInt8).null, 0)
      end
    end
  end

  def on_pause : Nil
    set_activity_state(:pause)
  end

  def on_stop : Nil
    set_activity_state(:stop)
  end

  def on_destroy : Nil
    @mutex.synchronize do
      write_cmd(:destroy)
      until @destroyed
        @cond.wait(@mutex)
      end
    end

    @msg_read.close
    @msg_write.close
  end

  def on_window_focus_changed(has_focus : Bool) : Nil
    if has_focus
      write_cmd(:gained_focus)
    else
      write_cmd(:lost_focus)
    end
  end

  def on_native_window_created(window : NativeWindow) : Nil
    set_window(window)
  end

  def on_native_window_resized(window : NativeWindow) : Nil
    write_cmd(:window_resized)
  end

  def on_native_window_redraw_needed(window : NativeWindow) : Nil
    write_cmd(:window_redraw_needed)
  end

  def on_native_window_destroyed(window : NativeWindow) : Nil
    set_window(nil)
  end

  def on_input_queue_created(queue : InputQueue) : Nil
    set_input(queue)
  end

  def on_input_queue_destroyed(queue : InputQueue) : Nil
    set_input(nil)
  end

  def on_content_rect_changed(rect : Rect) : Nil
    @mutex.synchronize do
      @content_rect = rect
    end
    write_cmd(:content_rect_changed)
  end

  def on_configuration_changed : Nil
    write_cmd(:config_changed)
  end

  def on_low_memory : Nil
    write_cmd(:low_memory)
  end

  private def set_window(window : NativeWindow?)
    @mutex.synchronize do
      write_cmd(:term_window) if @pending_window
      @pending_window = window
      write_cmd(:init_window) if window
      until @window == @pending_window
        @cond.wait(@mutex)
      end
    end
  end

  private def set_input(input_queue : InputQueue?)
    @mutex.synchronize do
      @pending_input_queue = input_queue
      write_cmd(:input_changed)
      until @input_queue == @pending_input_queue
        @cond.wait(@mutex)
      end
    end
  end

  private def set_activity_state(cmd : Command)
    @mutex.synchronize do
      write_cmd(cmd)
      while @activity_state != cmd
        @cond.wait(@mutex)
      end
    end
  end

  private def pre_exec_cmd(cmd : Command)
    case cmd
    when .input_changed?
      @mutex.synchronize do
        @input_queue.try &.detach_looper
        @input_queue = @pending_input_queue
        @input_queue.try &.attach_looper(looper, LOOPER_ID_INPUT)
        @cond.broadcast
      end
    when .init_window?
      @mutex.synchronize do
        @window = @pending_window
        @cond.broadcast
      end
    when .term_window?
      @cond.broadcast
    when .start?, .pause?, .resume?, .stop?
      @mutex.synchronize do
        @activity_state = cmd
        @cond.broadcast
      end
    when .save_state?
      free_saved_state
    when .config_changed?
      configuration.load_from(@activity.asset_manager)
      print_cur_config
    when .destroy?
      @destroy_requested = true
    end
  end

  private def post_exec_cmd(cmd : Command)
    case cmd
    when .term_window?
      @mutex.synchronize do
        @window = nil
        @cond.broadcast
      end
    when .save_state?
      @mutex.synchronize do
        @state_saved = true
        @cond.broadcast
      end
    when .resume?
      free_saved_state
    end
  end

  private def print_cur_config
    config = self.configuration
    str = String.build do |io|
      io << "Config:"
      io << " mcc=" << config.mcc
      io << " mnc=" << config.mnc
      io << " lang=" << config.language
      io << " cnt=" << config.country
      io << " orien=" << config.orientation
      io << " touch=" << config.touchscreen
      io << " dens=" << config.density
      io << " keys=" << config.keyboard
      io << " nav=" << config.navigation
      io << " keysHid=" << config.keys_hidden
      io << " navHid=" << config.nav_hidden
      io << " sdk=" << config.sdk_version
      io << " size=" << config.screen_size
      io << " long=" << config.screen_long
      io << " modetype=" << config.ui_mode_type
      io << " modenight=" << config.ui_mode_night
    end
    Log.write :verbose, "NATIVE_ACTIVITY", str
  end
end

lib LibC
  PTHREAD_CREATE_DETACHED = 1
  PTHREAD_CREATE_JOINABLE = 0

  fun pthread_attr_init(__attr : PthreadAttrT*) : Int
  fun pthread_attr_setdetachstate(__attr : PthreadAttrT*, __state : Int) : Int
end

class Thread
  def initialize(*, detached : Bool, &@func : ->)
    ret = LibC.pthread_attr_init(out attr)
    unless ret == 0
      LibC.pthread_attr_destroy(pointerof(attr))
      raise RuntimeError.from_os_error("pthread_attr_init", Errno.new(ret))
    end
    detach_state = detached ? LibC::PTHREAD_CREATE_DETACHED : LibC::PTHREAD_CREATE_JOINABLE
    LibC.pthread_attr_setdetachstate(pointerof(attr), detach_state)

    @th = uninitialized LibC::PthreadT

    ret = GC.pthread_create(pointerof(@th), pointerof(attr), ->(data : Void*) {
      (data.as(Thread)).start
      Pointer(Void).null
    }, self.as(Void*))

    if ret != 0
      raise RuntimeError.from_os_error("pthread_create", Errno.new(ret))
    end
  end
end
