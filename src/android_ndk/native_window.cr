require "./lib/native_window"

class AndroidNDK::NativeWindow
  def initialize(@data : Lib::ANativeWindow*)
  end

  def to_unsafe
    @data
  end

  def_equals_and_hash @data
end
