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
      include Decoder
      extend Forwardable

      attr_reader :resume, :locale

      def self.start
        ArgumentParser.parse
        resume = FetchResumeService.fetch_resume
        new(resume).start
      rescue ArgumentError, NetworkConnectionError => e
        Output.message(e.messages)
        exit
      end

      def initialize(resume)
        @resume = resume
        @installer = Installer.new(resume[:dependencies])
      end

      def_delegators :@installer, :installation_required?,
                                  :dependencies_present?,
                                  :request_dependency_installation,
                                  :install, :uninstall

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
