require 'forwardable'
require_relative 'argument_parser'
require_relative 'fetch_resume_service'
require_relative 'messages'
require_relative 'installer'
require_relative 'file_system'
require_relative 'output'

module Resume
  module CLI
    class Application
      include Messages, Decoder
      extend Forwardable

      attr_reader :resume, :locale, :filename

      def self.start
        ArgumentParser.parse
        resume = FetchResumeService.fetch_resume
        new(resume, locale).start
      rescue ArgumentError, NetworkConnectionError => e
        Output.message(e)
        exit
      end

      def initialize(resume, locale)
        @resume = resume
        @locale = locale
        @filename = "#{d(resume[:document_name])}_#{locale}.pdf"
        @installer = Installer.new(self)
        initialize_messages
      end

      def_delegators :@installer, :installation_required?,
                                  :dependencies_present?,
                                  :install, :uninstall, :gems, :fonts

      def start
        install_dependencies if installation_required?
        generate_resume
        clean_up if dependencies_present?
        open_resume
      end

      private

      def install_dependencies
        request_dependency_installation
        if permission_granted?
          install
        else
          inform_of_failure_to_generate_resume
          exit
        end
      end

      def generate_resume
        inform_start_of_resume_generation
        PDF::Document.generate(self)
        inform_of_successful_resume_generation
      end

      def open_resume
        request_to_open_resume
        FileSystem.open_document(self) if permission_granted?
        thank_user_for_generating_resume
      end

      def clean_up
        request_to_clean_up
        uninstall if permission_granted?
      end

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end
