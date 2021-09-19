require "forwardable"
require_relative "../output"
require_relative "../pdf/document"
require_relative "settings"
require_relative "argument_parser"
require_relative "resume_data_fetcher"
require_relative "exceptions"
require_relative "dependency_manager"
require_relative "content_parser"
require_relative "file_system"

module Resume
  module CLI
    # The entry point for starting the CLI.
    #
    # @author Paul Fioravanti
    class Application
      extend Forwardable

      POSITIVE_INPUT = /\A(y|yes)\z/i
      private_constant :POSITIVE_INPUT

      # Configures and calls to start the CLI.
      #
      # @return [nil]
      def self.start
        Settings.configure
        catch(:halt) do
          ArgumentParser.parse
          resume = ResumeDataFetcher.fetch
          new(resume).start
        end
      rescue Error => error
        Output.messages(error.messages)
      end

      def self.permission_granted?
        # NOTE: Change back to `match?` when AppVeyor gets a Ruby 2.4 build.
        Kernel.gets.chomp.match(POSITIVE_INPUT)
      end
      private_class_method :permission_granted?

      private_class_method :new

      # Creates a new instance of the CLI Application
      #
      # @param resume [Hash] The hash containing resume data.
      # @return [Application]
      def initialize(resume)
        @resume = resume
        @dependency_manager =
          DependencyManager.new(resume[:dependencies])
      end

      def_delegators :@dependency_manager,
                     :installation_required?,
                     :request_dependency_installation,
                     :install

      # Starts the CLI.
      #
      # @raise [DependencyInstallationPermissionError]
      #   if permission is not granted to install dependencies.
      # @return [nil]
      def start
        install_dependencies if installation_required?
        generate_resume
        open_resume
      end

      private

      attr_accessor :resume, :title, :filename

      def install_dependencies
        request_dependency_installation
        # rubocop:disable Style/GuardClause
        # NOTE: I think a non-guard clause reads better here
        if self.class.__send__(:permission_granted?)
          Output.success(:thank_you_kindly)
          install
        else
          raise DependencyInstallationPermissionError
        end
        # rubocop:enable Style/GuardClause
      end

      def generate_resume
        prepare_resume_data
        Output.plain(:generating_pdf)
        PDF::Document.generate(resume, title, filename)
        Output.success(:resume_generated_successfully)
      end

      def prepare_resume_data
        self.resume = ContentParser.parse(resume)
        self.title = resume[:title]
        self.filename = "#{title}_#{I18n.locale}.pdf"
      end

      def open_resume
        Output.question(:would_you_like_me_to_open_the_resume)
        if self.class.__send__(:permission_granted?)
          FileSystem.open_document(filename)
        end
        Output.info(:thanks_for_looking_at_my_resume, filename: filename)
      end
    end
  end
end
