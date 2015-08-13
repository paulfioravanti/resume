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
        @warning = :supported_locales_are
      end
    end

    class InvalidOptionError < ArgumentError
      attr_reader :error, :raw

      def initialize(string)
        @error = :you_have_some_invalid_options
        @raw = string
      end
    end

    class MissingArgumentError < ArgumentError
      attr_reader :error, :raw

      def initialize(string)
        @error = :you_have_a_missing_argument
        @raw = string
      end
    end
  end
end
