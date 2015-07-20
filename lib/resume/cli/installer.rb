module Resume
  module CLI
    class Installer

      attr_reader :app, :gems, :fonts

      def initialize(app)
        @app = app
        @gems = initialize_gem_dependencies
        @fonts = initialize_font_dependencies
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
        gems.any? || app.locale == :ja
      end

      def install
        app.thank_user_for_permission
        app.inform_start_of_gem_installation
        if gems_successfully_installed? && fonts_successfully_installed?
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
        { 'prawn' => '2.0.2', 'prawn-table' => '0.2.2' }.tap do |gems|
          gems['zip'] = '2.0.2' if app.locale == :ja
        end
      end

      def initialize_font_dependencies
        return unless app.locale == :ja
        {
          ipa: {
            file_name: 'IPAfont00303.zip',
            location: 'http://ipafont.ipa.go.jp/ipafont/IPAfont00303.php',
            fonts: {
              mincho: 'ipamp.ttf',
              gothic: 'ipagp.ttf'
            }
          }
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

      def fonts_successfully_installed?
        return true unless app.locale == :ja
        puts "Downloading fonts. This may take a while..."
        fonts.all? do |_, font_type|
          font_file = font_type[:file_name]
          # FIXME: Fix this conditional
          unless File.exist?('IPAfont00303.zip')
            open(font_file, 'wb') do |file|
              open(font_type[:location]) do |uri|
                file.write(uri.read)
              end
            end
          end
          require 'zip'
          Zip::File.open(font_file) do |file|
            file.each do |entry|
              font_type[:fonts].each do |_, file_name|
                if entry.name.match(file_name)
                  # FIXME: Fix this conditional
                  unless File.exist?(file_name)
                    entry.extract(file_name)
                  end
                  break # inner loop only
                end
              end
            end
          end
        end
      end
    end
  end
end
