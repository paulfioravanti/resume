module Resume
  module CLI
    class GemInstaller

      attr_reader :app, :gems

      def initialize(app)
        @app = app
        @gems = initialize_gem_dependencies
      end

      def installation_required?
        gems.each do |name, version|
          begin
            if already_installed?(name, version)
              gems.delete(name) # remove dependency to install
            end
          rescue Gem::LoadError
            # gem not installed: leave in the gems list
            next
          end
        end
        !gems.empty?
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

      def initialize_gem_dependencies
        {
          'prawn' => '2.0.1',
          'prawn-table' => '0.2.1'
        }
      end

      def already_installed?(name, version)
        Gem::Specification.find_by_name(name).version ==
          Gem::Version.new(version)
      end

      def gems_successfully_installed?
        gems.all? do |gem, version|
          system('gem', 'install', gem, '-v', version)
        end
      end
    end
  end
end

