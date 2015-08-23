require 'forwardable'
require_relative 'gem_installer'
require_relative 'font_downloader'
require_relative 'exceptions'

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

      def install
        if gems_successfully_installed? && fonts_successfully_downloaded?
          Output.success(:dependencies_successfully_installed)
        else
          fail DependencyInstallationError
        end
      end

      def dependencies_present?
        gems.any? || fonts.any?
      end

      def request_dependency_installation
        Output.warning(:i_need_the_following_to_generate_a_pdf)
        output_gem_dependencies if gems.any?
        output_font_dependencies if fonts.any?
        Output.question(:may_i_please_install_them)
      end
    end
  end
end
