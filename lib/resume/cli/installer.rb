require 'forwardable'
require 'tmpdir'
require_relative '../network_connection_error'
require_relative 'gem_installer'

module Resume
  module CLI
    class Installer
      extend Forwardable

      def initialize(dependencies)
        @gem_installer = GemInstaller.new(dependencies[:gems])
        @fonts = dependencies[:fonts]
      end

      def_delegators :@gem_installer, :gems,
                                      :audit_gem_dependencies,
                                      :output_gem_dependencies,
                                      :gems_successfully_installed?

      def installation_required?
        audit_gem_dependencies
        audit_font_dependencies
        dependencies_present?
      end

      def install
        if gems_successfully_installed? && fonts_successfully_installed?
          Output.success(:dependencies_successfully_installed)
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
          output_gem_dependencies
        end
        if fonts.any?
          Output.warning(:custom_fonts)
        end
        Output.question(:may_i_please_install_them)
      end

      private

      attr_accessor :fonts

      def audit_font_dependencies
        fonts.each do |font|
          if files_present?(font[:files].values)
            fonts.delete(font)
          end
        end
      end

      def files_present?(files)
        files.all? do |file|
          File.exist?(File.join(Dir.tmpdir, file))
        end
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
