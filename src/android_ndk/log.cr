require "./lib/log"

# Support routines to send messages to the Android log buffer, which can later
# be accessed through the `logcat` utility.
#
# Each log message must have
#
# * a priority
# * a log tag
# * some text
#
# The tag normally corresponds to the component that emits the log message, and
# should be reasonably small.
#
# Log message text may be truncated to less than an implementation-specific
# limit (1023 bytes).
#
# Note that a newline character (`\n`) will be appended automatically to your
# log message, if not already there. It is not possible to send several messages
# and have them appear on a single line in logcat.
#
# Please use logging in moderation:
#
# * Sending log messages eats CPU and slow down your application and the system.
# * The circular log buffer is pretty small, so sending many messages will hide
#   other important log messages.
# * In release builds, only send log messages to account for exceptional
#   conditions.
module AndroidNDK::Log
  # Android log priority values, in increasing order of priority.
  enum Priority
    # Verbose logging. Should typically be disabled for a release apk.
    Verbose = Lib::LogPriority::VERBOSE

    # Debug logging. Should typically be disabled for a release apk.
    Debug = Lib::LogPriority::DEBUG

    # Informational logging. Should typically be disabled for a release apk.
    Info = Lib::LogPriority::INFO

    # Warning logging. For use with recoverable failures.
    Warn = Lib::LogPriority::WARN

    # Error logging. For use with unrecoverable failures.
    Error = Lib::LogPriority::ERROR

    # Fatal logging. For use when aborting.
    Fatal = Lib::LogPriority::FATAL
  end

  # Writes the constant string *text* to the log, with priority *prio* and tag
  # *tag*.
  def self.write(prio : Priority, tag : String, text : String) : Nil
    Lib.__android_log_write(prio.value, tag.check_no_null_byte("tag"), text.check_no_null_byte("text"))
  end

  # Writes a formatted string to the log, with priority *prio* and tag *tag*.
  # The details of formatting are the same as for `LibC.printf`.
  def self.print(prio : Priority, tag : String, fmt : String, *args) : Nil
    Lib.__android_log_print(prio.value, tag.check_no_null_byte("tag"), fmt.check_no_null_byte("fmt"), *args)
  end

  # Writes an assertion failure to the log (as `Priority::Fatal`) and to
  # stderr, before calling `LibC.abort`.
  #
  # If *fmt* is non-`nil`, *cond* is unused. If *fmt* is `nil`, the string
  # `"Assertion failed: %s"` is used with `cond` as the string argument.
  # If both *fmt* and *cond* are `nil`, a default string is provided.
  #
  # Most callers should use `LibC.assert` instead, or the `__assert` and
  # `__assert2` functions provided by bionic if more control is needed. They
  # support automatically including the source filename and line number more
  # conveniently than this function.
  def self.assert(tag : String, fmt : String, *args) : NoReturn
    Lib.__android_log_assert(cond.check_no_null_byte("cond"), tag.check_no_null_byte("tag"), fmt.check_no_null_byte("fmt"), *args)
  end

  # Writes an assertion failure to the log (as `Priority::Fatal`) and to
  # stderr, before calling `LibC.abort`. The string `"Assertion failed: %s"` is
  # used with `cond` as the string argument.
  #
  # Most callers should use `LibC.assert` instead, or the `__assert` and
  # `__assert2` functions provided by bionic if more control is needed. They
  # support automatically including the source filename and line number more
  # conveniently than this function.
  def self.assert(tag : String, fmt : Nil, cond : String) : NoReturn
    Lib.__android_log_assert(cond.check_no_null_byte("cond"), tag.check_no_null_byte("tag"), nil)
  end

  # Writes an assertion failure to the log (as `Priority::Fatal`) and to
  # stderr, before calling `LibC.abort`. A default string is provided.
  #
  # Most callers should use `LibC.assert` instead, or the `__assert` and
  # `__assert2` functions provided by bionic if more control is needed. They
  # support automatically including the source filename and line number more
  # conveniently than this function.
  def self.assert(tag : String) : NoReturn
    Lib.__android_log_assert(nil, tag.check_no_null_byte("tag"), nil)
  end
end
