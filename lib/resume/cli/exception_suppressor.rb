module Resume
  module ExceptionSuppressor
    def self.extended(base)
      base.send(:private_class_method, :suppress)
    end

    private

    def suppress(exception_to_ignore = StandardError, default = nil)
      yield
    rescue Exception => e
      raise unless e.is_a?(exception_to_ignore)
      default.respond_to?(:call) ? default.call : default
    end
  end
end
