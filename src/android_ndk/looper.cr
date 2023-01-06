require "./lib/looper"

# A looper is the state tracking an event loop for a thread. Loopers do not
# define event structures or other such things; rather they are a lower-level
# facility to attach one or more discrete objects listening for an event. An
# "event" here is simply data available on a file descriptor: each attached
# object has an associated file descriptor, and waiting for "events" means
# (internally) polling on all of these file descriptors until one or more of
# them have data available.
#
# A thread can have only one ALooper associated with it.
class AndroidNDK::Looper
  private def initialize(@data : Lib::ALooper*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data

  # Returns the looper associated with the calling thread, or `nil` if there is
  # not one.
  def self.for_thread : self?
    data = Lib.ALooper_forThread
    new(data) if data
  end

  # Prepares a looper associated with the calling thread, and returns it.
  # If the thread already has a looper, it is returned. Otherwise, a new
  # one is created, associated with the thread, and returned.
  #
  # If *allow_non_callbacks* is true, this looper will accept calls to `#add_fd`
  # that do not have a callback (that is provide `nil` for the callback). In
  # this case the caller of `poll_once` or `poll_all` MUST check the return from
  # these functions to discover when data is available on such fds and process
  # it.
  def self.prepare(*, allow_non_callbacks : Bool = false) : self
    opts = allow_non_callbacks ? Lib::ALOOPER_PREPARE_ALLOW_NON_CALLBACKS : 0
    new(Lib.ALooper_prepare(opts))
  end

  # Acquires a reference on `self. This prevents the object from being deleted
  # until the reference is removed. This is only needed to safely hand a
  # `Looper` from one thread to another.
  def acquire : Nil
    Lib.ALooper_acquire(self)
  end

  # Removes a reference that was previously acquired with `#acquire`.
  def release : Nil
    Lib.ALooper_release(self)
  end

  # Flags for file descriptor events that a looper can monitor.
  #
  # These flag bits can be combined to monitor multiple events at once.
  @[Flags]
  enum Event
    # The file descriptor is available for read operations.
    Input = Lib::ALOOPER_EVENT_INPUT

    # The file descriptor is available for write operations.
    Output = Lib::ALOOPER_EVENT_OUTPUT

    # The file descriptor has encountered an error condition.
    #
    # The looper always sends notifications about errors; it is not necessary
    # to specify this event flag in the requested event set.
    Error = Lib::ALOOPER_EVENT_ERROR

    # The file descriptor was hung up. For example, indicates that the remote
    # end of a pipe or socket was closed.
    #
    # The looper always sends notifications about hangups; it is not necessary
    # to specify this event flag in the requested event set.
    HangUp = Lib::ALOOPER_EVENT_HANGUP

    # The file descriptor is invalid. For example, the file descriptor was
    # closed prematurely.
    #
    # The looper always sends notifications about invalid file descriptors; it
    # is not necessary to specify this event flag in the requested event set.
    Invalid = Lib::ALOOPER_EVENT_INVALID
  end

  record PollFd, fd : Int32, ident : Int32, events : Event

  # Special result from `Looper.poll_once` and `Looper.poll_all`.
  enum PollStatus
    # The poll was awoken using `Looper#wake` before the timeout expired and no
    # callbacks were executed and no other file descriptors were ready.
    Wake = Lib::ALOOPER_POLL_WAKE

    # Result from `Looper.poll_once`: One or more callbacks were executed.
    Callback = Lib::ALOOPER_POLL_CALLBACK

    # Result from `Looper.poll_once` and `Looper.poll_all`: The timeout expired.
    Timeout = Lib::ALOOPER_POLL_TIMEOUT

    # Result from `Looper.poll_once` and `Looper.poll_all`: An error occurred.
    Error = Lib::ALOOPER_POLL_ERROR
  end

  alias PollResult = PollFd | PollStatus

  # Waits for events to be available, with optional timeout in milliseconds.
  # Invokes callbacks for all file descriptors on which an event occurred.
  #
  # If the timeout is zero or negative, returns immediately without blocking. If
  # the timeout is `nil`, waits indefinitely until an event appears.
  #
  # Returns `PollStatus::Wake` if the poll was awoken using `#wake` before the
  # timeout expired and no callbacks were invoked and no other file descriptors
  # were ready.
  #
  # Returns `PollStatus::Callback` if one or more callbacks were invoked.
  #
  # Returns `PollStatus::Timeout` if there was no data before the given timeout
  # expired.
  #
  # Returns `PollStatus::Error` if an error occurred.
  #
  # Returns a `PollFd` containing an identifier (the same identifier `ident`
  # passed to `#add_fd`) if its file descriptor has data and it has no callback
  # function (requiring the caller here to handle it). In this (and only this)
  # case `PollFd#events` will contain the poll events associated with the fd.
  #
  # This method does not return until it has finished invoking the appropriate
  # callbacks for all file descriptors that were signalled.
  def self.poll_once(timeout_millis : Int32?) : PollResult
    timeout = timeout_millis ? {timeout_millis, 0}.max : -1
    ident = Lib.ALooper_pollOnce(timeout, out fd, out events, nil)
    if ident >= 0
      PollFd.new(fd: fd, ident: ident, events: Event.from_value(events))
    else
      PollStatus.from_value(ident)
    end
  end

  # Like `poll_once`, but performs all pending callbacks until all data has been
  # consumed or a file descriptor is available with no callback. This function
  # will never return `PollStatus::Callback`.
  def self.poll_all(timeout_millis : Int32?) : PollResult
    timeout = timeout_millis ? {timeout_millis, 0}.max : -1
    ident = Lib.ALooper_pollAll(timeout, out fd, out events, nil)
    if ident >= 0
      PollFd.new(fd: fd, ident: ident, events: Event.from_value(events))
    else
      PollStatus.from_value(ident)
    end
  end

  # Wakes the poll asynchronously.
  #
  # This method can be called on any thread. This method returns immediately.
  def wake : Nil
    Lib.ALooper_wake(self)
  end

  # Adds a new file descriptor to be polled by the looper. If the same file
  # descriptor was previously added, it is replaced.
  #
  # * *fd* is the file descriptor to be added.
  # * *ident* is an identifier for this event, which is returned from
  #   `poll_once`. The identifier must be >= 0.
  # * *events* are the poll events to wake up on. Typically this is
  #   `Event::Input`.
  #
  # The *ident* will be returned by `poll_once` when its file descriptor has
  # data available, requiring the caller to take care of processing it.
  #
  # Returns `true` if the file descriptor was added or `false` if an error
  # occurred.
  #
  # This method can be called on any thread. This method may block briefly if it
  # needs to wake the poll.
  def add_fd(fd : Int32, events : Event, *, ident : Int32) : Bool
    raise ArgumentError.new "`ident` must be >= 0" unless ident >= 0
    Lib.ALooper_addFd(self, fd, ident, events.value, nil, nil) != -1
  end

  # Adds a new file descriptor to be polled by the looper. If the same file
  # descriptor was previously added, it is replaced.
  #
  # * *fd* is the file descriptor to be added.
  # * *events* are the poll events to wake up on. Typically this is
  #   `Event::Input`.
  # * *callback* is the function to call when there is an event on the file
  #   descriptor. It is given the file descriptor it is associated with, and
  #   the poll events that were triggered. Implementations should return `true`
  #   to continue receiving callbacks, or `false` to have this file descriptor
  #   and callback unregistered from the looper.
  #
  # `callback` will be called when there is data on the file descriptor.
  # It should execute any events it has pending, appropriately reading from the
  # file descriptor.
  #
  # Returns `true` if the file descriptor was added or `false` if an error
  # occurred.
  #
  # This method can be called on any thread. This method may block briefly if it
  # needs to wake the poll.
  def add_fd(fd : Int32, events : Event, &callback : Int32, Event -> Bool) : Bool
    @@callbacks[{self, fd}] = box = Box.box(callback)
    callback2 = ->(fd : LibC::Int, events : LibC::Int, data : Void*) : LibC::Int do
      original_callback = Box(typeof(callback)).unbox(data)
      original_callback.call(fd, Event.from_value(events)) ? 1 : 0
    end
    Lib.ALooper_addFd(self, fd, Lib::ALOOPER_POLL_CALLBACK, events.value, callback2, box) != -1
  end

  @@callbacks = {} of {Looper, Int32} => Void*

  # Removes a previously added file descriptor from the looper.
  #
  # When this method returns, it is safe to close the file descriptor since the
  # looper will no longer have a reference to it. However, it is possible for
  # the callback to already be running or for it to run one last time if the
  # file descriptor was already signalled. Calling code is responsible for
  # ensuring that this case is safely handled. For example, if the callback
  # takes care of removing itself during its own execution either by returning 0
  # or by calling this method, then it can be guaranteed to not be invoked again
  # at any later time unless registered anew.
  #
  # Returns `true` if the file descriptor was removed, `false` if none was
  # previously registered or raises `RuntimeError` if an error occurred.
  #
  # This method can be called on any thread. This method may block briefly if it
  # needs to wake the poll.
  def remove_fd(fd : Int32) : Bool
    result = Lib.ALooper_removeFd(self, fd)
    raise RuntimeError.new if result == -1
    @@callbacks.delete({self, fd})
    result != 0
  end
end
