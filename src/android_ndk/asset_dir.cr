require "./asset"

# `AssetDir` provides access to a chunk of the asset hierarchy as if it were a
# single directory. The contents are populated by the `AssetManager`.
#
# The list of files will be sorted in ascending order by ASCII value.
#
# ## Crystal-exclusive
#
# Every `AssetDir` is also an `::Iterator` and can be used in single-pass
# algorithms. Using `#next` instead of `#next_file_name` also automatically
# closes the directory after the last file is returned.
class AndroidNDK::AssetDir
  include Iterator(String)

  def initialize(@data : Lib::AAssetDir*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data

  # Iterates over the files in an asset directory. `nil` is returned when all
  # the file names have been returned.
  #
  # The returned file name is relative to this directory and suitable for
  # passing to `AssetManager#open`.
  def next_file_name : String?
    ptr = Lib.AAssetDir_getNextFileName(self)
    String.new(ptr) if ptr
  end

  # Iterator adapter for `#next_file_name`. Returns `Iterator::Stop::INSTANCE`
  # instead of `nil` and closes the directory if all the file names have already
  # been returned.
  def next : String | Iterator::Stop
    filename = next_file_name
    return filename if filename

    close
    Iterator::Stop::INSTANCE
  end

  # Resets the iteration state of `#next_file_name` to the beginning.
  #
  # NOTE: This also affects `#next`'s state, but will not work if `#next` has
  # closed this directory after returning all the files.
  def rewind : Nil
    Lib.AAssetDir_rewind(self)
  end

  # Closes an opened `AssetDir`, freeing any related resources.
  def close : Nil
    Lib.AAssetDir_close(self)
  end
end
