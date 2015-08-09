module Resume
  module CLI
    # None of these errors can be internationalised due to them
    # occurring before a locale is set
    class ArgumentError < StandardError; end

    class LocaleNotSupportedError < ArgumentError
      attr_reader :error_message, :warning_message

      def initialize(locale)
        @error_message =
          I18n.t('inform_locale_not_supported', locale: locale)
        @warning_message =
          I18n.t(
            'inform_of_supported_locales',
            supported_locales: I18n.available_locales.join(', ')
          )
      end
    end

    class InvalidOptionError < ArgumentError
      attr_reader :error_message, :info_message

      def initialize(info_message)
        @error_message = I18n.t('inform_of_invalid_options')
        @info_message = info_message
      end
    end

    class MissingArgumentError < ArgumentError
      attr_reader :error_message, :info_message

      def initialize(info_message)
        @error_message = I18n.t('inform_of_missing_argument')
        @info_message = info_message
      end
    end
  end
end
