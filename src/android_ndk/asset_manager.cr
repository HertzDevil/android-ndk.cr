require "./asset_dir"

# `AssetManager` provides access to an application's raw assets by creating
# `Asset` objects.
#
# `AssetManager` is a wrapper to the low-level native implementation of the java
# `AssetManager`, a pointer can be obtained using `AssetManager.from_java`.
#
# The asset hierarchy may be examined like a filesystem, using `AssetDir`
# objects to peruse a single directory.
#
# A native `AssetManager` may be shared across multiple threads.
class AndroidNDK::AssetManager
  # Available access modes for opening assets with `AssetManager#open`.
  enum AssetMode
    # No specific information about how data will be accessed.
    Unknown = Lib::AASSET_MODE_UNKNOWN

    # Read chunks, and seek forward and backward.
    Random = Lib::AASSET_MODE_RANDOM

    # Read sequentially, with an occasional forward seek.
    Streaming = Lib::AASSET_MODE_STREAMING

    # Caller plans to ask for a read-only buffer with all data.
    Buffer = Lib::AASSET_MODE_BUFFER
  end

  def initialize(@data : Lib::AAssetManager*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data

  # Opens the named directory within the asset hierarchy. The directory can then
  # be inspected with the `AssetDir` functions. To open the top-level directory,
  # pass in "" as the *dir_name*.
  #
  # The object returned here should be freed by calling `AssetDir#close`.
  def open_dir(dir_name : String) : AssetDir
    AssetDir.new(Lib.AAssetManager_openDir(self, dir_name.check_no_null_byte("dir_name")))
  end

  # Opens the named directory within the asset hierarchy, yields it to the given
  # block, then closes the directory.
  def open_dir(dir_name : String, & : AssetDir -> T) : T forall T
    dir = open_dir(dir_name)
    begin
      yield dir
    ensure
      dir.close
    end
  end

  # Iterates over the files in the given directory, yielding each file name to
  # the given block.
  #
  # The file names are relative to the given directory.
  def each_dir_file(dir_name : String, & : String ->) : Nil
    open_dir(dir_name) do |dir|
      while filename = dir.next_file_name
        yield filename
      end
    end
  end

  # Opens an asset.
  #
  # The object returned here should be freed by calling `Asset#close`.
  def open(filename : String, mode : AssetMode = :unknown) : Asset
    Asset.new(Lib.AAssetManager_open(self, filename.check_no_null_byte("filename"), mode.value))
  end

  # Opens an asset, yields it to the given block, then closes the asset.
  def open(filename : String, mode : AssetMode = :unknown, & : Asset -> T) : T forall T
    asset = open(filename, mode)
    begin
      yield asset
    ensure
      asset.close
    end
  end

  # Returns the content of *filename* as a string.
  def read(filename : String) : String
    open(filename, :streaming) do |file|
      String.build(file.size) do |io|
        IO.copy(file, io)
      end
    end
  end
end
