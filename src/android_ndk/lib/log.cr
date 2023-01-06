# <android/log.h>

require "./types"

@[Link("log")]
module AndroidNDK
  lib Lib
    enum LogPriority : Int
      UNKNOWN
      DEFAULT
      VERBOSE
      DEBUG
      INFO
      WARN
      ERROR
      FATAL
      SILENT
    end

    fun __android_log_write(prio : Int, tag : Char*, text : Char*) : Int
    fun __android_log_print(prio : Int, tag : Char*, fmt : Char*, ...) : Int
    fun __android_log_vprint(prio : Int, tag : Char*, fmt : Char*, ap : VaList) : Int
    fun __android_log_assert(cond : Char*, tag : Char*, fmt : Char*, ...) : NoReturn
  end
end
