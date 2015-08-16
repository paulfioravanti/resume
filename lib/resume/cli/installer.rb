require 'tmpdir'
require_relative '../network_connection_error'

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
        if gems_successfully_installed? && fonts_successfully_installed?
          Output.success(:dependencies_successfully_installed)
          # Reset the dir and path values so Prawn can be required
          Gem.clear_paths
        else
          Output.error(:dependency_installation_failed)
          exit
        end
      end

      def dependencies_present?
        gems.any? || fonts.any?
      end

      def request_dependency_installation
        Output.warning(:i_need_the_following_to_generate_a_pdf)
        if gems.any?
          Output.warning(:ruby_gems)
          gems.each do |name, version|
            Output.plain([
              :gem_name_and_version, { name: name, version: version }
            ])
          end
        end
        if fonts.any?
          Output.warning(:custom_fonts)
        end
        Output.question(:may_i_please_install_them)
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
            fonts.delete(font)
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
      rescue SocketError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      def fonts_successfully_installed?
        fonts.all? do |font|
          Output.plain([
            :downloading_font,
            { file_name: font[:file_name], location: font[:location] }
          ])
          download_font_file(font)
          extract_fonts(font)
        end
      end

      def download_font_file(font)
        open(File.join(Dir.tmpdir, font[:file_name]), 'wb') do |file|
          open(font[:location]) do |uri|
            file.write(uri.read)
          end
        end
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      def extract_fonts(font)
        require 'zip'
        Zip::File.open(File.join(Dir.tmpdir, font[:file_name])) do |file|
          file.each do |entry|
            font[:files].each do |_, file_name|
              if entry.name.match(file_name)
                # overwrite any existing files with true block
                entry.extract(File.join(Dir.tmpdir, file_name)) { true }
                break # inner loop only
              end
            end
          end
        end
      end
    end
  end
end
