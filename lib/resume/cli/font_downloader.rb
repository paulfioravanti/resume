require 'tmpdir'
require_relative '../output'
require_relative '../exceptions'
require_relative 'file_system'
require_relative 'file_fetcher'
require_relative 'content_parser'

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
          Output.plain(:downloading_font)
          download_font_file(font[:location])
          extract_fonts(font)
        end
      rescue NetworkConnectionError
        false
      end

      private

      def files_present?(files)
        files.all? { |file| File.file?(FileSystem.tmpfile_path(file)) }
      end

      def download_font_file(font_location)
        FileFetcher.fetch(
          ContentParser.decode_content(font_location)
        )
      end

      def extract_fonts(font)
        require 'zip'
        Zip::File.open(FileSystem.tmpfile_path(font[:filename])) do |file|
          file.each do |entry|
            font[:files].each do |_, filename|
              if entry.name.match(filename)
                # overwrite any existing files with true block
                entry.extract(FileSystem.tmpfile_path(filename)) { true }
                break # inner loop only
              end
            end
          end
        end
      end
    end
  end
end
