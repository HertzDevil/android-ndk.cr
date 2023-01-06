require "./lib/native_activity"
require "./asset_manager"
require "./input_queue"
require "./native_window"
require "./rect"

# This class defines the native side of an `android.app.NativeActivity`. It is
# created by the framework, and handed to the application's native code as it is
# being launched.
class AndroidNDK::NativeActivity
  # These are the callbacks the framework makes into a native application. All
  # of these callbacks happen on the main thread of the application.
  abstract class Callbacks
    # `NativeActivity` has started. See Java documentation for
    # `Activity.onStart()` for more information.
    abstract def on_start : Nil

    # `NativeActivity` has resumed. See Java documentation for
    # `Activity.onResume()` for more information.
    abstract def on_resume : Nil

    # Framework is asking `NativeActivity` to save its current instance state.
    # See Java documentation for `Activity.onSaveInstanceState()` for more
    # information. The returned `Bytes` needs to be allocated with
    # `LibC.malloc`; the framework will call `LibC.free` on it for you. Note
    # that the saved state will be persisted, so it can not contain any active
    # entities (pointers to memory, file descriptors, etc).
    abstract def on_save_instance_state : Bytes

    # `NativeActivity` has paused. See Java documentation for
    # `Activity.onPause()` for more information.
    abstract def on_pause : Nil

    # `NativeActivity` has stopped. See Java documentation for
    # `Activity.onStop()` for more information.
    abstract def on_stop : Nil

    # `NativeActivity` is being destroyed. See Java documentation for
    # `Activity.onDestroy()` for more information.
    abstract def on_destroy : Nil

    # Focus has changed in this `NativeActivity`'s window. This is often used,
    # for example, to pause a game when it loses input focus.
    abstract def on_window_focus_changed(has_focus : Bool) : Nil

    # The drawing window for this `NativeActivity` has been created. You can use
    # the given native window object to start drawing.
    abstract def on_native_window_created(window : NativeWindow) : Nil

    # The drawing window for this `NativeActivity` has been resized. You should
    # retrieve the new size from the window and ensure that your rendering in it
    # now matches.
    abstract def on_native_window_resized(window : NativeWindow) : Nil

    # The drawing window for this `NativeActivity` needs to be redrawn. To avoid
    # transient artifacts during screen changes (such resizing after rotation),
    # applications should not return from this function until they have finished
    # drawing their window in its current state.
    abstract def on_native_window_redraw_needed(window : NativeWindow) : Nil

    # The drawing window for this native activity is going to be destroyed. You
    # MUST ensure that you do not touch the window object after returning from
    # this function: in the common case of drawing to the window from another
    # thread, that means the implementation of this callback must properly
    # synchronize with the other thread to stop its drawing before returning
    # from here.
    abstract def on_native_window_destroyed(window : NativeWindow) : Nil

    # The input queue for this native activity's window has been created. You
    # can use the given input queue to start retrieving input events.
    abstract def on_input_queue_created(queue : InputQueue) : Nil

    # The input queue for this native activity's window is being destroyed. You
    # should no longer try to reference this object upon returning from this
    # function.
    abstract def on_input_queue_destroyed(queue : InputQueue) : Nil

    # The rectangle in the window in which content should be placed has changed.
    abstract def on_content_rect_changed(rect : Rect) : Nil

    # The current device `Configuration` has changed. The new configuration can
    # be retrieved from `NativeActivity#asset_manager`.
    abstract def on_configuration_changed : Nil

    # The system is running low on memory. Use this callback to release
    # resources you do not need, to help the system avoid killing more important
    # processes.
    abstract def on_low_memory : Nil
  end

  @callbacks : Callbacks?

  def initialize(@data : Lib::ANativeActivity*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data

  # Path to this application's internal data directory.
  def internal_data_path : String
    String.new(@data.value.internalDataPath)
  end

  # Path to this application's external (removable/mountable) data directory.
  def external_data_path : String
    String.new(@data.value.externalDataPath)
  end

  # The platform's SDK version code.
  def sdk_version : Int32
    @data.value.sdkVersion
  end

  # The `AssetManager` instance for the application. The application uses this
  # to access binary assets bundled inside its own .apk file.
  def asset_manager : AssetManager
    AssetManager.new(@data.value.assetManager)
  end

  # Available starting with Honeycomb: path to the directory containing the
  # application's OBB files (if any). If the app doesn't have any OBB files,
  # this directory may not exist.
  def obb_path : String?
    if pointer = @data.value.obbPath
      String.new(pointer)
    end
  end

  # Finishes this activity. Its Java `finish()` method will be called, causing
  # it to be stopped and destroyed. Note that this method can be called from
  # *any* thread; it will send a message to the main thread of the process where
  # the Java call will take place.
  def finish : Nil
    Lib.ANativeActivity_finish(self)
  end

  # Changes the window format of this activity. Calls `getWindow().setFormat()`
  # of this activity. Note that this method can be called from *any* thread; it
  # will send a message to the main thread of the process where the Java call
  # will take place.
  # def window_format=(format : Int32) : Int32
  #   Lib.ANativeActivity_setWindowFormat(self, format)
  #   format
  # end

  # Changes the window flags of this activity. Calls `getWindow().setFlags()`
  # of this activity. Note that this method can be called from *any* thread; it
  # will send a message to the main thread of the process where the Java call
  # will take place. See `window.h` for flag constants.
  # def set_window_flags

  # def show_soft_input

  # def hide_soft_input

  def bind_callbacks(@callbacks : Callbacks)
    @data.value.instance = callbacks.as(Void*)

    @data.value.callbacks.value.onStart = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_start
    end

    @data.value.callbacks.value.onResume = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_resume
    end

    @data.value.callbacks.value.onSaveInstanceState = ->(activity : Lib::ANativeActivity*, out_len : LibC::SizeT*) do
      bytes = activity.value.instance.as(Callbacks).on_save_instance_state
      out_len.value = LibC::SizeT.new(bytes.size)
      bytes.to_unsafe.as(Void*)
    end

    @data.value.callbacks.value.onPause = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_pause
    end

    @data.value.callbacks.value.onStop = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_stop
    end

    @data.value.callbacks.value.onDestroy = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_destroy
    end

    @data.value.callbacks.value.onWindowFocusChanged = ->(activity : Lib::ANativeActivity*, has_focus : LibC::Int) do
      activity.value.instance.as(Callbacks).on_window_focus_changed(has_focus != 0)
    end

    @data.value.callbacks.value.onNativeWindowCreated = ->(activity : Lib::ANativeActivity*, window : Lib::ANativeWindow*) do
      activity.value.instance.as(Callbacks).on_native_window_created(NativeWindow.new(window))
    end

    @data.value.callbacks.value.onNativeWindowResized = ->(activity : Lib::ANativeActivity*, window : Lib::ANativeWindow*) do
      activity.value.instance.as(Callbacks).on_native_window_resized(NativeWindow.new(window))
    end

    @data.value.callbacks.value.onNativeWindowRedrawNeeded = ->(activity : Lib::ANativeActivity*, window : Lib::ANativeWindow*) do
      activity.value.instance.as(Callbacks).on_native_window_redraw_needed(NativeWindow.new(window))
    end

    @data.value.callbacks.value.onNativeWindowDestroyed = ->(activity : Lib::ANativeActivity*, window : Lib::ANativeWindow*) do
      activity.value.instance.as(Callbacks).on_native_window_destroyed(NativeWindow.new(window))
    end

    @data.value.callbacks.value.onInputQueueCreated = ->(activity : Lib::ANativeActivity*, queue : Lib::AInputQueue*) do
      activity.value.instance.as(Callbacks).on_input_queue_created(InputQueue.new(queue))
    end

    @data.value.callbacks.value.onInputQueueDestroyed = ->(activity : Lib::ANativeActivity*, queue : Lib::AInputQueue*) do
      activity.value.instance.as(Callbacks).on_input_queue_destroyed(InputQueue.new(queue))
    end

    @data.value.callbacks.value.onContentRectChanged = ->(activity : Lib::ANativeActivity*, rect : Lib::ARect*) do
      activity.value.instance.as(Callbacks).on_content_rect_changed(Rect.new(rect.value))
    end

    @data.value.callbacks.value.onConfigurationChanged = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_configuration_changed
    end

    @data.value.callbacks.value.onLowMemory = ->(activity : Lib::ANativeActivity*) do
      activity.value.instance.as(Callbacks).on_low_memory
    end
  end
end
