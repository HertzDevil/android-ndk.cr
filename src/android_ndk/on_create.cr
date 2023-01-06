require "./runtime_ext"
require "../android_ndk"

# The name of the function that `NativeInstance` looks for when launching its
# native code. This is the default function that is used, you can specify
# "android.app.func_name" string meta-data in your manifest to use a different
# function.
fun app_main = ANativeActivity_onCreate(activity : AndroidNDK::Lib::ANativeActivity*, savedState : Void*, savedStateSize : LibC::SizeT)
  AndroidNDK.unsafe_initialize(activity, savedState, savedStateSize)

  # a placeholder ARGV must be defined here, otherwise `::PROGRAM_NAME` will
  # fail to initialize
  argv0 = "(???)".to_unsafe
  argv = uninitialized UInt8*[1]
  argv.to_unsafe[0] = argv0

  # the following is based on `Crystal.main(&)` except that we don't call `exit`
  exception = nil
  begin
    GC.init
    Crystal.main_user_code(argv.size, argv.to_unsafe)
  rescue ex
    exception = ex
  end

  Crystal::AtExitHandlers.run(exception ? 1 : 0, exception)
  if exception
    Crystal::System.print_exception("Unhandled exception", exception)
  end
end
