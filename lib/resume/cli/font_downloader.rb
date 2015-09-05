require 'tmpdir'
require_relative '../exceptions'
require_relative '../file_system'
require_relative '../output'
require_relative '../file_fetcher'

module Resume
  module CLI
    class FontDownloader
      attr_reader :fonts

      def initialize(fonts)
        @fonts = fonts
      end

      def audit_font_dependencies
        fonts.each do |font|
          fonts.delete(font) if files_present?(font[:files].values)
        end
      end

      def output_font_dependencies
        return if fonts.none?
        Output.warning(:custom_fonts)
      end

      def fonts_successfully_downloaded?
        return true if fonts.none?
        fonts.all? do |font|
          Output.plain([
            :downloading_font,
            { file_name: font[:file_name], location: font[:location] }
          ])
          download_font_file(font)
          extract_fonts(font)
        end
      rescue NetworkConnectionError
        false
      end

      private

      def files_present?(files)
        files.all? { |file| File.file?(FileSystem.tmp_filepath(file)) }
      end

      def download_font_file(font)
        FileFetcher.fetch(
          font[:location],
          filename: font[:file_name],
          mode: 'wb'
        )
      end

      def extract_fonts(font)
        require 'zip'
        Zip::File.open(FileSystem.tmp_filepath(font[:filename])) do |file|
          file.each do |entry|
            font[:files].each do |_, filename|
              if entry.name.match(filename)
                # overwrite any existing files with true block
                entry.extract(FileSystem.tmp_filepath(filename)) { true }
                break # inner loop only
              end
            end
          end
        end
      end
    end
  end
end
