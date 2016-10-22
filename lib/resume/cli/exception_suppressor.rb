module Resume
  module CLI
    module ExceptionSuppressor
      module_function

      def suppress(exception_to_ignore = StandardError, default = -> {})
        yield
      rescue Exception => exception
        raise unless exception.is_a?(exception_to_ignore)
        default.call
      end
    end
  end
end
