require 'forwardable'
require_relative 'argument_parser'
require_relative 'messages'
require_relative 'gem_installer'
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
        @installer = GemInstaller.new(self)
        initialize_messages
      end

      def_delegators :@installer, :installation_required?, :install

      def start
        install_gems if installation_required?
        generate_resume
        open_resume
      end

      private

      def install_gems
        request_gem_installation
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
        print_thank_you_message
      end

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end

