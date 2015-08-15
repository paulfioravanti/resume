require 'forwardable'
require_relative '../decoder'
require_relative 'argument_parser'
require_relative 'fetch_resume_service'
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
                                  :install

      def start
        install_dependencies if installation_required?
        generate_resume
        open_resume
      end

      private

      def install_dependencies
        request_dependency_installation
        if permission_granted?
          install
        else
          Output.message(
            error: :cannot_generate_pdf_without_dependencies
          )
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

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end
