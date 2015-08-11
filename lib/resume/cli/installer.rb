require 'tmpdir'

module Resume
  module CLI
    class Installer

      attr_reader :gems, :fonts

      def initialize(dependencies)
        @gems = dependencies[:gems]
        @fonts = dependencies[:fonts]
      end

      def installation_required?
        audit_gem_dependencies
        audit_font_dependencies
        dependencies_present?
      end

      def install
        app.thank_user_for_permission
        app.inform_start_of_gem_installation
        if gems_successfully_installed? && fonts_successfully_installed?
          app.inform_of_successful_installation
          # Reset the dir and path values so Prawn can be required
          Gem.clear_paths
        else
          app.inform_of_installation_failure
          exit
        end
      end

      def uninstall
        app.inform_start_of_dependency_removal
        gems.each do |gem, version|
          system('gem', 'uninstall', '-I', gem, '-v', version)
        end
        fonts.values.each do |font|
          FileUtils.rm([font[:file_name], *font[:fonts].values])
        end
        app.inform_of_successful_dependency_removal
      end

      def dependencies_present?
        gems.any? || fonts.any?
      end

      private

      def audit_gem_dependencies
        gems.each do |name, version|
          begin
            if gem_already_installed?(name, version)
              gems.delete(name) # remove dependency to install
            end
          rescue Gem::LoadError
            # gem not installed: leave in the gems list
            next
          end
        end
      end

      def audit_font_dependencies
        fonts.each do |font_type, font|
          if files_present?(font[:files].values)
            fonts.delete(font_type)
          end
        end
      end

      def gem_already_installed?(name, version)
        Gem::Specification.find_by_name(name).version ==
          Gem::Version.new(version)
      end

      def files_present?(files)
        files.all? do |file|
          File.exist?(File.join(Dir.tmpdir, file))
        end
      end

      def gems_successfully_installed?
        gems.all? do |gem, version|
          system('gem', 'install', gem, '-v', version)
        end
      end

      def fonts_successfully_installed?
        fonts.values.all? do |font|
          app.inform_start_of_font_download(font)
          download_font_file(font)
          extract_fonts(font)
        end
      end

      def download_font_file(font)
        open(font[:file_name], 'wb') do |file|
          open(font[:location]) do |uri|
            file.write(uri.read)
          end
        end
      end

      def extract_fonts(font)
        require 'zip'
        Zip::File.open(font[:file_name]) do |file|
          file.each do |entry|
            font[:fonts].each do |_, file_name|
              if entry.name.match(file_name)
                # overwrite any existing files with true block
                entry.extract(file_name) { true }
                break # inner loop only
              end
            end
          end
        end
      end
    end
  end
end
