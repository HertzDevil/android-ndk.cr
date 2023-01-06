# <android/native_window.h>

require "./api_level"
require "./rect"

module AndroidNDK
  lib Lib
    enum ANativeWindow_LegacyFormat
      WINDOW_FORMAT_RGBA_8888 = 1 # AHARDWAREBUFFER_FORMAT_R8G8B8A8_UNORM
      WINDOW_FORMAT_RGBX_8888 = 2 # AHARDWAREBUFFER_FORMAT_R8G8B8X8_UNORM
      WINDOW_FORMAT_RGB_565   = 4 # AHARDWAREBUFFER_FORMAT_R5G6B5_UNORM
    end

    enum ANativeWindowTransform
      ANATIVEWINDOW_TRANSFORM_IDENTITY          = 0x00
      ANATIVEWINDOW_TRANSFORM_MIRROR_HORIZONTAL = 0x01
      ANATIVEWINDOW_TRANSFORM_MIRROR_VERTICAL   = 0x02
      ANATIVEWINDOW_TRANSFORM_ROTATE_90         = 0x04
      ANATIVEWINDOW_TRANSFORM_ROTATE_180        = ANATIVEWINDOW_TRANSFORM_MIRROR_HORIZONTAL | ANATIVEWINDOW_TRANSFORM_MIRROR_VERTICAL
      ANATIVEWINDOW_TRANSFORM_ROTATE_270        = ANATIVEWINDOW_TRANSFORM_ROTATE_180 | ANATIVEWINDOW_TRANSFORM_ROTATE_90
    end

    alias ANativeWindow = Void

    struct ANativeWindow_Buffer
      width : Int32
      height : Int32
      stride : Int32
      format : Int32
      bits : Void*
      reversed : UInt32[6]
    end

    fun ANativeWindow_acquire(window : ANativeWindow*)
    fun ANativeWindow_release(window : ANativeWindow*)
    fun ANativeWindow_getWidth(window : ANativeWindow*) : Int32
    fun ANativeWindow_getHeight(window : ANativeWindow*) : Int32
    fun ANativeWindow_getFormat(window : ANativeWindow*) : Int32
    fun ANativeWindow_setBuffersGeometry(window : ANativeWindow*, width : Int32, height : Int32, format : Int32) : Int32
    fun ANativeWindow_lock(window : ANativeWindow*, outBuffer : ANativeWindow_Buffer*, inOutDirtyBounds : ARect*) : Int32
    fun ANativeWindow_unlockAndPost(window : ANativeWindow*) : Int32
    {% if ANDROID_API >= 26 %}
      fun ANativeWindow_setBuffersTransform(window : ANativeWindow*, transform : Int32) : Int32
    {% end %}
    {% if ANDROID_API >= 28 %}
      fun ANativeWindow_setBuffersDataSpace(window : ANativeWindow*, dataSpace : Int32) : Int32
      fun ANativeWindow_getBuffersDataSpace(window : ANativeWindow*) : Int32
    {% end %}
    {% if ANDROID_API >= 30 %}
      enum ANativeWindow_FrameRateCompatibility : Int8
        ANATIVEWINDOW_FRAME_RATE_COMPATIBILITY_DEFAULT      = 0
        ANATIVEWINDOW_FRAME_RATE_COMPATIBILITY_FIXED_SOURCE = 1
      end

      fun ANativeWindow_setFrameRate(window : ANativeWindow*, frameRate : Float, compatibility : Int8) : Int32
      fun ANativeWindow_tryAllocateBuffers(window : ANativeWindow*)
    {% end %}
    {% if ANDROID_API >= 31 %}
      enum ANativeWindow_ChangeFrameRateStrategy : Int8
        ANATIVEWINDOW_CHANGE_FRAME_RATE_ONLY_IF_SEAMLESS = 0
        ANATIVEWINDOW_CHANGE_FRAME_RATE_ALWAYS           = 1
      end

      fun ANativeWindow_setFrameRateWithChangeStrategy(window : ANativeWindow*, frameRate : Float, compatibility : Int8, changeFrameRateStrategy : Int8) : Int32
    {% end %}
  end
end
