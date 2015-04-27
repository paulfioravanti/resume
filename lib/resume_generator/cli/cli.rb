$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', 'resume')
require 'cli/messages'
require 'resume'
require 'cli/resume_option_parser'
require 'cli/gem_installer'
require 'cli/file_system'

module ResumeGenerator
  PRAWN_VERSION = '2.0.0'
  PRAWN_TABLE_VERSION = '0.2.1'

  def self.locale
    @@locale
  end

  def self.locale=(locale)
    @@locale = locale
  end

  module CLI
    class CLI
      include Decoder, Messages

      attr_reader :locale

      def self.start(args)
        opt_parser = ResumeOptionParser.generate
        opt_parser.parse!(args)
        new.start
      end

      def initialize
        @locale = ResumeGenerator.locale
        initialize_messages
      end

      def start
        install_gems
        generate_resume
        open_resume
      end

      private

      def install_gems
        installer = GemInstaller.new(self)
        return if installer.required_gems_available?
        request_gem_installation
        if permission_granted?
          thank_user_for_permission
          inform_start_of_gem_installation
          installer.install_gems
        else
          inform_of_failure_to_generate_resume
          exit
        end
      end

      def generate_resume
        gem 'prawn', PRAWN_VERSION
        gem 'prawn-table', PRAWN_TABLE_VERSION
        require 'prawn'
        require 'prawn/table'
        inform_start_of_resume_generation
        Resume.generate(self)
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
