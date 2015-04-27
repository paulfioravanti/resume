module ResumeGenerator
  module CLI
    class GemInstaller

      attr_reader :cli, :gems

      def initialize(cli)
        @cli = cli
        @gems = {
          'prawn' => PRAWN_VERSION,
          'prawn-table' => PRAWN_TABLE_VERSION
        }
      end

      def required_gems_available?
        gems.each do |name, version|
          if Gem::Specification.find_by_name(name).version <
            Gem::Version.new(version)
            return false
          end
        end
        true
      rescue Gem::LoadError # gem not installed
        false
      end

      def install_gems
        if gems_successfully_installed?
          cli.inform_of_successful_gem_installation
          # Reset the dir and path values so Prawn can be required
          Gem.clear_paths
        else
          cli.inform_of_gem_installation_failure
          exit
        end
      end

      def gems_successfully_installed?
        system('gem', 'install', 'prawn', '-v', PRAWN_VERSION) &&
        system('gem', 'install', 'prawn-table', '-v', PRAWN_TABLE_VERSION)
      end
    end
  end
end

