require "./input_event"

# An input queue is the facility through which you retrieve input events.
class AndroidNDK::InputQueue
  def initialize(@data : Lib::AInputQueue*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data

  # Adds this input queue to a looper for processing. See `Looper#add_fd` for
  # information on the *ident* param.
  def attach_looper(looper : Looper, ident : Int32) : Nil
    Lib.AInputQueue_attachLooper(self, looper, ident, nil, nil)
  end

  # Adds this input queue to a looper for processing. See `Looper#add_fd` for
  # information on the *callback* param.
  def attach_looper(looper : Looper, &callback : Int32, Event -> Bool) : Nil
    @@callbacks[{self, looper, fd}] = box = Box.box(callback)
    callback2 = ->(fd : LibC::Int, events : LibC::Int, data : Void*) : LibC::Int do
      original_callback = Box(typeof(callback)).unbox(data)
      original_callback.call(fd, Event.from_value(events)) ? 1 : 0
    end
    Lib.AInputQueue_attachLooper(self, looper, Lib::ALOOPER_POLL_CALLBACK, callback2, box)
  end

  @@callbacks = {} of {InputQueue, Looper, Int32} => Void*

  # Removes the input queue from the looper it is currently attached to.
  def detach_looper : Nil
    Lib.AInputQueue_detachLooper(self)
  end

  # Returns true if there are one or more events available in the input queue.
  # Returns `true` if the queue has events; `false` if it does not have events;
  # and raises `RuntimeError` if there is an error.
  def has_events? : Bool
    result = Lib.AInputQueue_hasEvents(self)
    raise RuntimeError.new if result < 0
    result != 0
  end

  # Returns the next available event from the queue. Returns `nil` if no events
  # are available or an error has occurred.
  def get_event : InputEvent?
    result = Lib.AInputQueue_getEvent(self, out event)
    InputEvent.new(event) if result >= 0 && event
  end

  # Sends the key for standard pre-dispatching -- that is, possibly deliver it
  # to the current IME to be consumed before the app. Returns `false` if it was
  # not pre-dispatched, meaning you can process it right now. If `true` is
  # returned, you must abandon the current event processing and allow the event
  # to appear again in the event queue (if it does not get consumed during
  # pre-dispatching).
  def pre_dispatch_event(event : InputEvent) : Bool
    Lib.AInputQueue_preDispatchEvent(self, event) != 0
  end

  # Report that dispatching has finished with the given event. This must be
  # called after receiving an event with `#get_event`.
  def finish_event(event : InputEvent, handled : Bool) : Nil
    Lib.AInputQueue_finishEvent(self, event, handled ? 1 : 0)
  end
end
