require 'forwardable'
require_relative 'argument_parser'
require_relative 'messages'
require_relative 'installer'
require_relative 'file_system'

module Resume
  module CLI
    class Application
      include Messages
      extend Forwardable

      attr_reader :locale
      attr_accessor :filename

      def self.start
        parser = ArgumentParser.new
        parser.parse
        new(parser.locale).start
      end

      def initialize(locale)
        @locale = locale
        @installer = Installer.new(self)
        initialize_messages
      end

      def_delegators :@installer, :installation_required?,
                                  :install, :gems, :fonts

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

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end
