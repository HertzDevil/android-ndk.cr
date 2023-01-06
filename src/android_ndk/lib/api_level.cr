# <android/api-level.h>

require "./types"

module AndroidNDK
  lib Lib
    ANDROID_API_FUTURE = 10000

    ANDROID_API = 24

    ANDROID_API_G     =  9
    ANDROID_API_I     = 14
    ANDROID_API_J     = 16
    ANDROID_API_J_MR1 = 17
    ANDROID_API_J_MR2 = 18
    ANDROID_API_K     = 19
    ANDROID_API_L     = 21
    ANDROID_API_L_MR1 = 22
    ANDROID_API_M     = 23
    ANDROID_API_N     = 24
    ANDROID_API_N_MR1 = 25
    ANDROID_API_O     = 26
    ANDROID_API_O_MR1 = 27
    ANDROID_API_P     = 28
    ANDROID_API_Q     = 29
    ANDROID_API_R     = 30
    ANDROID_API_S     = 31
    ANDROID_API_T     = 33
    ANDROID_API_U     = 34

    {% if ANDROID_API >= 24 %}
      fun android_get_application_target_sdk_version : Int
    {% end %}

    {% if ANDROID_API >= 29 %}
      fun android_get_device_api_level : Int
    {% end %}
  end
end
