module Resume
  module CLI
    class GemInstaller

      attr_reader :app, :gems

      def initialize(app)
        @app = app
        @gems = {
          'prawn' => PRAWN_VERSION,
          'prawn-table' => PRAWN_TABLE_VERSION
        }
      end

      def installation_required?
        gems.each do |name, version|
          if Gem::Specification.find_by_name(name).version <
            Gem::Version.new(version)
            return true
          end
        end
        false
      rescue Gem::LoadError # gem not installed
        true
      end

      def install
        app.thank_user_for_permission
        app.inform_start_of_gem_installation
        if gems_successfully_installed?
          app.inform_of_successful_gem_installation
          # Reset the dir and path values so Prawn can be required
          Gem.clear_paths
        else
          app.inform_of_gem_installation_failure
          exit
        end
      end

      private

      def gems_successfully_installed?
        gems.all? do |gem, version|
          system('gem', 'install', gem, '-v', version)
        end
      end
    end
  end
end

