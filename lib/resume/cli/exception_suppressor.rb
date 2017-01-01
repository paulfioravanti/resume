module Resume
  module CLI
    module ExceptionSuppressor
      module_function

      # rubocop:disable Lint/RescueException
      # NOTE: This method needs to rescue from LoadError and Gem::LoadError
      # which don't inherit from StandardError, hence needing to rescue from
      # the Exception class.
      def suppress(exception_to_ignore = StandardError, default = -> {})
        yield
      rescue Exception => exception
        raise unless exception.is_a?(exception_to_ignore)
        default.call
      end
      # rubocop:enable Lint/RescueException
    end
  end
end
