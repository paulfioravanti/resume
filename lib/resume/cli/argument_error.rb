module Resume
  module CLI
    class ArgumentError < StandardError; end

    class LocaleNotSupportedError < ArgumentError
      attr_reader :messages

      def initialize(locale)
        @messages = {
          error: [
            :locale_is_not_supported,
            { specified_locale: locale }
          ],
          warning: :supported_locales_are
        }
      end
    end

    class InvalidOptionError < ArgumentError
      attr_reader :messages

      def initialize(string)
        @messages = {
          error: :you_have_some_invalid_options,
          raw: string
        }
      end
    end

    class MissingArgumentError < ArgumentError
      attr_reader :messages

      def initialize(string)
        @messages = {
          error: :you_have_a_missing_argument,
          raw: string
        }
      end
    end
  end
end
