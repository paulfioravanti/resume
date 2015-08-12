module Resume
  module CLI
    # None of these errors can be internationalised due to them
    # occurring before a locale is set
    class ArgumentError < StandardError; end

    class LocaleNotSupportedError < ArgumentError
      attr_reader :error, :warning

      def initialize(locale)
        @error = [
          :locale_is_not_supported,
          { specified_locale: locale }
        ]
        @warning = [
          :supported_locales_are,
          { supported_locales: I18n.available_locales.join(', ') }
        ]
      end
    end

    class InvalidOptionError < ArgumentError
      attr_reader :error, :info

      def initialize(info)
        @error = :you_have_some_invalid_options
        @info = info
      end
    end

    class MissingArgumentError < ArgumentError
      attr_reader :error, :info

      def initialize(info)
        @error = :you_have_a_missing_argument
        @info = info
      end
    end
  end
end
