module Resume
  # Module encapsulating all the functionality of the command line
  # interface to generate the resume.
  #
  # @author Paul Fioravanti
  module CLI
    # Module concerned with suppressing exceptions of a specific type.
    #
    # @author Paul Fioravanti
    module ExceptionSuppressor
      module_function

      # Suppresses exception of type `exception_to_ignore` and `call`s
      # code contained inside `default` if exception is to be ignored.
      #
      # @param exception_to_ignore [Exception]
      #   The exception type to ignore.
      # @param default [Proc]
      #   The code to be executed when the exception is to be ignored.
      # @raise [Exception]
      #   The exception to be raised if it is not to be ignored.
      # @return the result of the passed-in lambda
      def suppress(exception_to_ignore = StandardError, default = ->{})
        yield
      # NOTE: This method needs to rescue from LoadError and Gem::LoadError
      # which don't inherit from StandardError, hence needing to rescue from
      # the Exception class.
      # rubocop:disable Lint/RescueException
      rescue Exception => exception
        raise exception unless exception.is_a?(exception_to_ignore)
        default.call
      end
      # rubocop:enable Lint/RescueException
    end
  end
end
