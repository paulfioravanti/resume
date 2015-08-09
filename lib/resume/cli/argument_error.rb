module Resume
  module CLI
    # None of these errors can be internationalised due to them
    # occurring before a locale is set
    class ArgumentError < StandardError; end

    class LocaleNotSupportedError < ArgumentError
      attr_reader :danger_message, :warning_message

      def initialize(locale, supported_locales)
        @danger_message =
          "Locale '#{locale}' is not supported."
        @warning_message =
          "Supported locales are: #{supported_locales.join(', ')}"
      end
    end

    class InvalidOptionError < ArgumentError
      attr_reader :danger_message, :info_message

      def initialize(info_message)
        @danger_message = 'You have some invalid options.'
        @info_message = info_message
      end
    end

    class MissingArgumentError < ArgumentError
      attr_reader :danger_message, :info_message

      def initialize(info_message)
        @danger_message =
          'You have a missing argument in one of your options.'
        @info_message = info_message
      end
    end
  end
end
