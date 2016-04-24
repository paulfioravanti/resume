module Resume
  module CLI
    module ExceptionSuppressor
      def self.extended(base)
        base.send(:private_class_method, :suppress)
      end

      private

      def suppress(exception_to_ignore = StandardError, default = -> {})
        yield
      rescue Exception => exception
        raise unless exception.is_a?(exception_to_ignore)
        default.call
      end
    end
  end
end
