# <android/native_activity.h>

require "./input"
require "./asset_manager"
require "./native_window"
require "./lib_jni"

module AndroidNDK
  lib Lib
    struct ANativeActivity
      callbacks : ANativeActivityCallbacks*
      vm : LibJNI::JavaVM*
      env : LibJNI::Env*
      clazz : LibJNI::JObject
      internalDataPath : Char*
      externalDataPath : Char*
      sdkVersion : Int32
      instance : Void*
      assetManager : AAssetManager*
      obbPath : Char*
    end

    struct ANativeActivityCallbacks
      onStart : (ANativeActivity*) ->
      onResume : (ANativeActivity*) ->
      onSaveInstanceState : (ANativeActivity*, SizeT*) -> Void*
      onPause : (ANativeActivity*) ->
      onStop : (ANativeActivity*) ->
      onDestroy : (ANativeActivity*) ->
      onWindowFocusChanged : (ANativeActivity*, Int) ->
      onNativeWindowCreated : (ANativeActivity*, ANativeWindow*) ->
      onNativeWindowResized : (ANativeActivity*, ANativeWindow*) ->
      onNativeWindowRedrawNeeded : (ANativeActivity*, ANativeWindow*) ->
      onNativeWindowDestroyed : (ANativeActivity*, ANativeWindow*) ->
      onInputQueueCreated : (ANativeActivity*, AInputQueue*) ->
      onInputQueueDestroyed : (ANativeActivity*, AInputQueue*) ->
      onContentRectChanged : (ANativeActivity*, ARect*) ->
      onConfigurationChanged : (ANativeActivity*) ->
      onLowMemory : (ANativeActivity*) ->
    end

    fun ANativeActivity_finish(activity : ANativeActivity*)
    fun ANativeActivity_setWindowFormat(activity : ANativeActivity*, format : Int32)
    fun ANativeActivity_setWindowFlags(activity : ANativeActivity*, addFlags : UInt32, removeFlags : UInt32)

    ANATIVEACTIVITY_SHOW_SOFT_INPUT_IMPLICIT = 0x0001
    ANATIVEACTIVITY_SHOW_SOFT_INPUT_FORCED   = 0x0002

    fun ANativeActivity_showSoftInput(activity : ANativeActivity*, flags : UInt32)

    ANATIVEACTIVITY_HIDE_SOFT_INPUT_IMPLICIT_ONLY = 0x0001
    ANATIVEACTIVITY_HIDE_SOFT_INPUT_NOT_ALWAYS    = 0x0002

    fun ANativeActivity_hideSoftInput(activity : ANativeActivity*, flags : UInt32)
  end
end
