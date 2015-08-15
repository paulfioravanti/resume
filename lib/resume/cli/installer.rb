require 'tmpdir'

module Resume
  module CLI
    class Installer

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
        Output.message(success: :thank_you_kindly)
        if gems_successfully_installed? && fonts_successfully_installed?
          Output.message(success: :dependencies_successfully_installed)
          # Reset the dir and path values so Prawn can be required
          Gem.clear_paths
        else
          Output.message(error: :dependency_installation_failed)
          exit
        end
      end

      def dependencies_present?
        gems.any? || fonts.any?
      end

      def request_dependency_installation
        Output.message(
          warning: :i_need_the_following_to_generate_a_pdf
        )
        if gems.any?
          Output.message(warning: :ruby_gems)
          gems.each do |name, version|
            Output.message([
              :gem_name_and_version,
              { name: name, version: version }
            ])
          end
        end
        if fonts.any?
          Output.message(warning: :custom_fonts)
        end
        Output.message(question: :may_i_please_install_them)
      end

      private

      attr_accessor :gems, :fonts

      def audit_gem_dependencies
        gems.each do |name, version|
          begin
            if gem_already_installed?(name, version)
              # remove dependency to install
              self.gems -= [[name, version]]
            end
          rescue Gem::LoadError
            # gem not installed: leave in the gems list
            next
          end
        end
      end

      def audit_font_dependencies
        fonts.each do |font|
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
        fonts.all? do |font|
          Output.message([
            :downloading_font,
            { file_name: font[:file_name], location: font[:location] }
          ])
          download_font_file(font)
          extract_fonts(font)
        end
      end

      def download_font_file(font)
        # TODO: Use this in the Tmp dir
        open(font[:file_name], 'wb') do |file|
          open(font[:location]) do |uri|
            file.write(uri.read)
          end
        end
      end

      def extract_fonts(font)
        # TODO: Extract in the tmp dir
        require 'zip'
        Zip::File.open(font[:file_name]) do |file|
          file.each do |entry|
            font[:files].each do |_, file_name|
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
