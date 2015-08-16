require 'forwardable'
require_relative '../decoder'
require_relative '../output'
require_relative 'argument_parser'
require_relative 'fetch_resume_service'
require_relative 'installer'
require_relative '../pdf/document'
require_relative 'file_system'

module Resume
  module CLI
    class Application
      include Decoder
      extend Forwardable

      attr_reader :resume, :locale
      attr_accessor :filename

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
          Output.message(error: :cannot_generate_pdf_without_dependencies)
          exit
        end
      end

      def generate_resume
        Output.message(info: :generating_pdf)
        self.filename = PDF::Document.generate(resume)
        Output.message(success: :resume_generated_successfully)
      end

      def open_resume
        Output.message(question: :would_you_like_me_to_open_the_resume)
        FileSystem.open_document(filename) if permission_granted?
        Output.message(thanks: [
          :thanks_for_looking_at_my_resume,
          { filename: filename }
        ])
      end

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end
