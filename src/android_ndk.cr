require "./android_ndk/lib/native_activity"

module AndroidNDK
  class_getter unsafe_native_activity : Lib::ANativeActivity*
  class_getter unsafe_saved_state : Bytes

  # these must be uninitialized because otherwise they will be rewritten at the
  # beginning of `Crystal.main_user_code`
  @@unsafe_native_activity = uninitialized Pointer(Lib::ANativeActivity)
  @@unsafe_saved_state = uninitialized Bytes

  # :nodoc:
  def self.unsafe_initialize(activity : Lib::ANativeActivity*, saved_state : Void*, saved_state_size : LibC::SizeT) : Nil
    @@unsafe_native_activity = activity

    # this must use `LibC.malloc` because the framework will deallocate it using
    # `LibC.free`
    @@unsafe_saved_state = Slice.new(LibC.malloc(saved_state_size).as(UInt8*), saved_state_size)
    @@unsafe_saved_state.copy_from(saved_state.as(UInt8*), saved_state_size)
  end
end
