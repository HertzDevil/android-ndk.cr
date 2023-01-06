module Crystal::System
  def self.print_error(message, *args)
    AndroidNDK::Log.print(:error, "android-ndk.cr", message, *args)
  end
end
