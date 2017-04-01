require "forwardable"
require_relative "../output"
require_relative "exceptions"
require_relative "gem_installer"
require_relative "font_downloader"

module Resume
  module CLI
    # Class concerned with managing the dependencies that generation
    # of the resume requires, which can vary depending on the resume's locale.
    #
    # @author Paul Fioravanti
    class DependencyManager
      extend Forwardable

      # Initialises a new instance of a Dependency Manager.
      #
      # @param dependencies [Hash]
      #   A hash containing the gem and font dependencies for resume generation.
      # @return [DependencyManager] The dependency manager object.
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

      # Determines whether gem or font dependencies are required to
      # generate resume.
      #
      # @return [true] if installation of dependencies required.
      # @return [false] if installation of dependencies not required.
      def installation_required?
        audit_gem_dependencies
        audit_font_dependencies
        dependencies_present?
      end

      # Asks the user generating the resume for permission to install
      # the required dependencies.
      #
      # @return [nil]
      def request_dependency_installation
        Output.warning(:i_need_the_following_to_generate_a_pdf)
        output_gem_dependencies
        output_font_dependencies
        Output.question(:may_i_please_install_them)
      end

      # Attempts to install the dependencies needed to
      # generate the resume.
      #
      # @raise [DependencyInstallationError]
      #   if any dependencies are unable to be installed.
      # @return [nil]
      #   if all dependencies are able to be installed.
      def install
        # rubocop:disable Style/GuardClause
        # NOTE: I think a non-guard clause reads better here
        if gems_successfully_installed? && fonts_successfully_downloaded?
          Output.success(:dependencies_successfully_installed)
        else
          raise DependencyInstallationError
        end
        # rubocop:enable Style/GuardClause
      end

      private

      def dependencies_present?
        gems.any? || fonts.any?
      end
    end
  end
end
