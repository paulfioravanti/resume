module Resume
  module CLI
    # The Base error class that all resume generation-related errors
    # inherit from.
    #
    # @author Paul Fioravanti
    class Error < StandardError
      # The messages for the error.
      #
      # @!attribute messages [r]
      # @return [Hash] The hash of error messages and their types.
      attr_reader :messages
    end

    # Error class for when the very basic prerequisites for running the
    # resume application are not met.
    #
    # @author Paul Fioravanti
    class DependencyPrerequisiteError < Error
      # Initialises a new instance of the error.
      #
      # @return [DependencyPrerequisiteError] The new error instance.
      def initialize
        @messages = {
          raw_error:
            "My resume and the specs are bilingual and need the I18n gem.",
          raw_warning: "Please run: gem install i18n"
        }
      end
    end

    # Error class for when a connection cannot be made to the internet
    # to fetch resources needed for resume generation.
    #
    # @author Paul Fioravanti
    class NetworkConnectionError < Error
      # Initialises a new instance of the error.
      #
      # @return [NetworkConnectionError] The new error instance.
      def initialize
        @messages = {
          error: :cant_connect_to_the_internet,
          warning: :please_check_your_network_settings
        }
      end
    end

    # Error class for when a permission is not given to download
    # assets needed for resume generation.
    #
    # @author Paul Fioravanti
    class DependencyInstallationPermissionError < Error
      # Initialises a new instance of the error.
      #
      # @return [DependencyInstallationPermissionError] The new error instance.
      def initialize
        @messages = {
          error: :cannot_generate_pdf_without_dependencies,
          warning: :please_ask_me_directly_for_a_pdf_copy
        }
      end
    end

    # Error class for when a installation of a required dependency
    # fails for whatever reason.
    #
    # @author Paul Fioravanti
    class DependencyInstallationError < Error
      # Initialises a new instance of the error.
      #
      # @return [DependencyInstallationError] The new error instance.
      def initialize
        @messages = {
          error: :dependency_installation_failed,
          warning: :try_again_or_ask_me_directly_for_a_pdf_copy
        }
      end
    end

    # Error class for when an invalid or unknown locale is specified
    # for resume generation.
    #
    # @author Paul Fioravanti
    class LocaleNotSupportedError < Error
      # Initialises a new instance of the error.
      #
      # @param error [String] The error message.
      # @return [LocaleNotSupportedError] The new error instance.
      def initialize(locale)
        super(locale)
        @messages = {
          raw_error: "Locale '#{locale}' is not supported",
          raw_warning: "Supported locales are: "\
                       "#{I18n.available_locales.join(', ')}"
        }
      end
    end

    # Error class for when an invalid option is given as a CLI parameter.
    #
    # @author Paul Fioravanti
    class InvalidOptionError < Error
      # Initialises a new instance of the error.
      #
      # @param error [String] The error message.
      # @return [InvalidOptionError] The new error instance.
      def initialize(error)
        super(error)
        @messages = {
          raw_error: "You have some invalid options.",
          raw: message
        }
      end
    end

    # Error class for when a required argument for a CLI option is missing.
    #
    # @author Paul Fioravanti
    class MissingArgumentError < Error
      # Initialises a new instance of the error.
      #
      # @param error [String] The error message.
      # @return [MissingArgumentError] The new error instance.
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
