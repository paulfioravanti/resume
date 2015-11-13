require 'forwardable'
require_relative '../output'
require_relative 'exceptions'
require_relative 'gem_installer'
require_relative 'font_downloader'

module Resume
  module CLI
    class DependencyManager
      extend Forwardable

      def initialize(dependencies)
        @gem_installer = GemInstaller.new(dependencies[:gems])
        @font_downloader = FontDownloader.new(dependencies[:fonts])
      end

      def_delegators :@gem_installer,
                     :gems,
                     :audit_gem_dependencies,
                     :output_gem_dependencies,
                     :gems_successfully_installed?

      def_delegators :@font_downloader,
                     :fonts,
                     :audit_font_dependencies,
                     :output_font_dependencies,
                     :fonts_successfully_downloaded?

      def installation_required?
        audit_gem_dependencies
        audit_font_dependencies
        dependencies_present?
      end

      def request_dependency_installation
        Output.warning(:i_need_the_following_to_generate_a_pdf)
        output_gem_dependencies
        output_font_dependencies
        Output.question(:may_i_please_install_them)
      end

      def install
        if gems_successfully_installed? && fonts_successfully_downloaded?
          Output.success(:dependencies_successfully_installed)
        else
          fail DependencyInstallationError
        end
      end

      private

      def dependencies_present?
        gems.any? || fonts.any?
      end
    end
  end
end
