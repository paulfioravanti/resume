module Resume
  module CLI
    class Error < StandardError
      attr_reader :messages
    end

    class DependencyPrerequisiteError < Error
      def initialize
        @messages = {
          raw_error:
            "My resume and the specs are bilingual and need the I18n gem.",
          raw_warning: "Please run: gem install i18n"
        }
      end
    end

    class NetworkConnectionError < Error
      def initialize
        @messages = {
          error: :cant_connect_to_the_internet,
          warning: :please_check_your_network_settings
        }
      end
    end

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
        super(locale)
        @messages = {
          raw_error: "Locale '#{locale}' is not supported",
          raw_warning: "Supported locales are: "\
                       "#{I18n.available_locales.join(', ')}"
        }
      end
    end

    class InvalidOptionError < Error
      def initialize(error)
        super(error)
        @messages = {
          raw_error: "You have some invalid options.",
          raw: message
        }
      end
    end

    class MissingArgumentError < Error
      def initialize(error)
        super(error)
        @messages = {
          raw_error: "You have a missing argument in "\
                     "one of your options.",
          raw: message
        }
      end
    end
  end
end
