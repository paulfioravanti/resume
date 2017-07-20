require_relative "../output"
require_relative "exceptions"
require_relative "exception_suppressor"

module Resume
  module CLI
    # Module concerned with the installation and dependency checking
    # of Ruby gems on to the system in order to generate the resume.
    #
    # @author Paul Fioravanti
    class GemInstaller
      extend Forwardable

      # @!attribute gems [r]
      # @return [Hash] The hash of gems to install.
      attr_reader :gems

      def self.gem_already_installed?(name, version)
        Gem::Specification.find_by_name(name).version ==
          Gem::Version.new(version)
      end
      private_class_method :gem_already_installed?

      # Initialises a new instance of a Gem Installer.
      #
      # @param gems [Hash]
      #   A hash containing the gem dependencies for the resume.
      # @return [GemInstaller]
      #   The gem installer object.
      def initialize(gems)
        @gems = gems
      end

      # Audits the local system to see if the necessary gems are installed.
      #
      # @return [Hash] The list of remaining gem dependencies to install.
      def audit_gem_dependencies
        gems.each do |name, version|
          # if gem not installed: leave in the gems list
          ExceptionSuppressor.suppress(Gem::LoadError, -> { next }) do
            if self.class.__send__(:gem_already_installed?, name, version)
              # remove dependency to install
              self.gems -= [[name, version]]
            end
          end
        end
      end

      # Outputs the name and version of the gems that must be installed
      # in order to generate the resume.
      #
      # @return [Hash] The list of dependencies to install.
      def output_gem_dependencies
        return if gems.none?
        Output.warning(:ruby_gems)
        gems.each do |name, version|
          Output.plain(
            [:gem_name_and_version, { name: name, version: version }]
          )
        end
      end

      # Attempts to install gem dependencies and reports back on
      # whether it was successful.
      #
      # @raise [NetworkConnectionError]
      #   if an internet connection is unavailable to download gems.
      # @return [true]
      #   if gem dependencies were successfully installed.
      # @return [false]
      #   if gem dependencies were not successfully installed.
      def gems_successfully_installed?
        return true if gems.none?
        Output.plain(:installing_ruby_gems)
        gems.all? do |gem_name, version|
          Kernel.system("gem", "install", gem_name, "-v", version)
        end
      rescue SocketError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      ensure
        # Reset dir and path values so just-installed gems can
        # be required, but also have this here so that the
        # return value for this method is a boolean
        Gem.clear_paths
      end

      private

      attr_writer :gems
    end
  end
end
