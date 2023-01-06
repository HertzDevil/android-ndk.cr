# <android/looper.h>

require "./types"

module AndroidNDK
  lib Lib
    alias ALooper = Void

    fun ALooper_forThread : ALooper*

    ALOOPER_PREPARE_ALLOW_NON_CALLBACKS = 1

    fun ALooper_prepare(opts : Int) : ALooper*

    ALOOPER_POLL_WAKE     = -1
    ALOOPER_POLL_CALLBACK = -2
    ALOOPER_POLL_TIMEOUT  = -3
    ALOOPER_POLL_ERROR    = -4

    fun ALooper_acquire(looper : ALooper*)
    fun ALooper_release(looper : ALooper*)

    ALOOPER_EVENT_INPUT   = 1 << 0
    ALOOPER_EVENT_OUTPUT  = 1 << 1
    ALOOPER_EVENT_ERROR   = 1 << 2
    ALOOPER_EVENT_HANGUP  = 1 << 3
    ALOOPER_EVENT_INVALID = 1 << 4

    alias ALooper_callbackFunc = Int, Int, Void* -> Int

    fun ALooper_pollOnce(timeoutMillis : Int, outFd : Int*, outEvents : Int*, outData : Void**) : Int
    fun ALooper_pollAll(timeoutMillis : Int, outFd : Int*, outEvents : Int*, outData : Void**) : Int
    fun ALooper_wake(looper : ALooper*)
    fun ALooper_addFd(looper : ALooper*, fd : Int, ident : Int, events : Int, callback : ALooper_callbackFunc, data : Void*) : Int
    fun ALooper_removeFd(looper : ALooper*, fd : Int) : Int
  end
end
