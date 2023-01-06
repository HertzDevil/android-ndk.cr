module AndroidNDK
  # :nodoc:
  module Private
    def self.nilable_unsafe(value)
      !value.nil? ? value.to_unsafe : typeof(value.to_unsafe).null
    end
  end
end
