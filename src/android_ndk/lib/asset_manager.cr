# <android/asset_manager.h>

module AndroidNDK
  lib Lib
    alias AAssetManager = Void
    alias AAssetDir = Void
    alias AAsset = Void

    AASSET_MODE_UNKNOWN   = 0
    AASSET_MODE_RANDOM    = 1
    AASSET_MODE_STREAMING = 2
    AASSET_MODE_BUFFER    = 3

    fun AAssetManager_openDir(mgr : AAssetManager*, dirName : Char*) : AAssetDir*
    fun AAssetManager_open(mgr : AAssetManager*, filename : Char*, mode : Int) : AAsset*

    fun AAssetDir_getNextFileName(assetDir : AAssetDir*) : Char*
    fun AAssetDir_rewind(assetDir : AAssetDir*)
    fun AAssetDir_close(assetDir : AAssetDir*)

    fun AAsset_read(asset : AAsset*, buf : Void*, count : SizeT) : Int
    fun AAsset_seek64(asset : AAsset*, offset : Off64T, whence : Int) : Off64T
    fun AAsset_close(asset : AAsset*)
    fun AAsset_getBuffer(asset : AAsset*) : Void*
    fun AAsset_getLength64(asset : AAsset*) : Off64T
    fun AAsset_getRemainingLength64(asset : AAsset*) : Off64T
    fun AAsset_openFileDescriptor64(asset : AAsset*, outStart : Off64T*, outLength : Off64T*) : Int
    fun AAsset_isAllocated(asset : AAsset*) : Int
  end
end
