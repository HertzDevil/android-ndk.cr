require "../log"
require "log"

module AndroidNDK::Util
  # The default log formatter for `LogcatBackend`.
  #
  # Equivalent to `::Log::ShortFormat` except that the timestamp, severity, and
  # source are not shown (as Logcat produces those fields already).
  ::Log.define_formatter LogcatFormatter,
    "#{message}#{data(before: " -- ")}#{context(before: " -- ")}#{exception}"

  # A `::Log::Backend` wrapper for Android's logging utilities.
  #
  # The "trace" and "notice" log severities are mapped to "verbose" and "info"
  # for Android; other log severities are unchanged.
  class LogBackend < ::Log::Backend
    def initialize(*, @formatter : ::Log::Formatter = LogcatFormatter, dispatch_mode : ::Log::DispatchMode = :sync)
      super(dispatch_mode)
    end

    def write(entry : ::Log::Entry)
      if prio = to_prio(entry.severity)
        io = String::Builder.new
        @formatter.format(entry, io)
        io.to_s.each_line do |line|
          Log.write(prio, entry.source, line)
        end
      end
    end

    private def to_prio(severity : ::Log::Severity)
      case severity
      in ::Log::Severity::Trace  then Log::Priority::Verbose
      in ::Log::Severity::Debug  then Log::Priority::Debug
      in ::Log::Severity::Info   then Log::Priority::Info
      in ::Log::Severity::Notice then Log::Priority::Info
      in ::Log::Severity::Warn   then Log::Priority::Warn
      in ::Log::Severity::Error  then Log::Priority::Error
      in ::Log::Severity::Fatal  then Log::Priority::Fatal
      in ::Log::Severity::None   then nil
      end
    end
  end
end
