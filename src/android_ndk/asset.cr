require "./lib/asset_manager"

# `Asset` provides access to a read-only asset.
#
# `Asset` objects are NOT thread-safe, and should not be shared across threads.
#
# ## Crystal-exclusive
#
# `Asset` inherits from `::IO` and overrides the following methods:
#
# * `#read`
# * `#write`
# * `#seek`
class AndroidNDK::Asset < IO
  def initialize(@data : Lib::AAsset*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data

  # Attempts to read data from the current offset into the given *slice*.
  #
  # Returns the number of bytes read, zero on EOF, or raises `IO::Error` on
  # error.
  def read(slice : Bytes) : Int
    raise ArgumentError.new "Can't write to read-only Slice" if slice.read_only?
    count = Lib.AAsset_read(self, slice, slice.size)
    count >= 0 ? count.to_i32 : raise IO::Error.new
  end

  # Raises `IO::Error`, as all `Asset`s are read-only.
  def write(slice : Bytes) : NoReturn
    raise IO::Error.new "Can't write to Asset"
  end

  # Seeks to the specified *offset* within the asset data.
  #
  # Returns the new position on success, or raises `IO::Error` on error.
  def seek(offset, whence : IO::Seek = IO::Seek::Set) : Int
    pos = Lib.AAsset_seek64(self, offset.to_i64, whence.value)
    pos != -1 ? pos.to_i64 : raise IO::Error.new
  end

  # Closes the asset, freeing all associated resources.
  def close : Nil
    Lib.AAsset_close(self)
  end

  # Gets a pointer to a buffer holding the entire contents of the asset.
  #
  # Returns a null pointer on failure.
  def buffer : UInt8*
    Lib.AAsset_getBuffer(self).as(UInt8*)
  end

  # Reports the total size of the asset data.
  def size : Int
    Lib.AAsset_getLength64(self)
  end

  # Returns a read-only slice of the entire contents of the asset. Raises
  # `IO::Error` on failure.
  def to_slice : Bytes
    buffer = self.buffer
    buffer ? Slice.new(buffer, size, read_only: true) : raise IO::Error.new
  end

  # Reports the total amount of asset data that can be read from the current
  # position.
  def remaining_size : Int
    Lib.AAsset_getRemainingLength64(self)
  end

  # Returns the current position of the asset data.
  def pos : Int
    size - remaining_size
  end

  def open_file_descriptor
    raise "TODO"
  end

  # Returns whether this asset's internal buffer is allocated in ordinary RAM
  # (i.e. not mmapped).
  def allocated? : Bool
    Lib.AAsset_isAllocated(self) != 0
  end
end
