require_relative '../exceptions'

module Resume
  module CLI
    class DependencyInstallationPermissionError < Error
      def initialize
        @messages = {
          error: :cannot_generate_pdf_without_dependencies,
          warning: :please_ask_me_directly_for_a_pdf_copy
        }
      end
    end

    class DependencyInstallationError < Error
      def initialize
        @messages = {
          error: :dependency_installation_failed,
          warning: :try_again_or_ask_me_directly_for_a_pdf_copy
        }
      end
    end

    class LocaleNotSupportedError < Error
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

    class InvalidOptionError < Error
      def initialize(string)
        @messages = {
          error: :you_have_some_invalid_options,
          raw: string
        }
      end
    end

    class MissingArgumentError < Error
      def initialize(string)
        @messages = {
          error: :you_have_a_missing_argument,
          raw: string
        }
      end
    end
  end
end
