require 'forwardable'
require_relative '../decoder'
require_relative '../output'
require_relative '../settings'
require_relative '../exceptions'
require_relative 'argument_parser'
require_relative 'resume_data_fetcher'
require_relative 'dependency_manager'
require_relative '../pdf/document'
require_relative '../file_system'

module Resume
  module CLI
    class Application
      extend Forwardable

      def self.start
        Settings.configure
        catch(:halt) do
          ArgumentParser.parse
          resume = ResumeDataFetcher.fetch
          new(resume).start
        end
      rescue Error => e
        Output.messages(e.messages)
      end

      private_class_method :new

      def initialize(resume)
        @resume = resume
        @dependency_manager =
          DependencyManager.new(resume[:dependencies])
        @title = Decoder.d(resume[:title])
        @filename = initialize_filename
      end

      def_delegators :@dependency_manager,
                     :installation_required?,
                     :request_dependency_installation,
                     :install

      def start
        install_dependencies if installation_required?
        generate_resume
        open_resume
      end

      private

      attr_reader :resume, :title, :filename

      def initialize_filename
        I18n.t(:filename, title: title, selected_locale: I18n.locale)
      end

      def install_dependencies
        request_dependency_installation
        if permission_granted?
          Output.success(:thank_you_kindly)
          install
        else
          fail DependencyInstallationPermissionError
        end
      end

      def generate_resume
        Output.plain(:generating_pdf)
        PDF::Document.generate(resume, title, filename)
        Output.success(:resume_generated_successfully)
      end

      def open_resume
        Output.question(:would_you_like_me_to_open_the_resume)
        FileSystem.open_document(filename) if permission_granted?
        Output.info([
          :thanks_for_looking_at_my_resume, { filename: filename }
        ])
      end

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end
