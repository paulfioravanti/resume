require "tmpdir"
require_relative "../output"
require_relative "exceptions"
require_relative "file_system"
require_relative "file_fetcher"
require_relative "content_parser"

module Resume
  module CLI
    class FontDownloader
      extend Forwardable

      attr_reader :fonts

      def self.local_files_present?(files)
        files.all? { |file| File.file?(FileSystem.tmpfile_path(file)) }
      end
      private_class_method :local_files_present?

      def self.download_font_file(font_location)
        FileFetcher.fetch(
          ContentParser.decode_content(font_location)
        )
      end
      private_class_method :download_font_file

      def self.extract_fonts(font)
        Zip::File.open(FileSystem.tmpfile_path(font[:filename])) do |file|
          file.each do |entry|
            font[:files].each do |_, filename|
              next unless entry.name.match(filename)
              # `true` in the block ensures any existing files are overwritten
              entry.extract(FileSystem.tmpfile_path(filename)) { true }
              break
            end
          end
        end
      end
      private_class_method :extract_fonts

      def initialize(fonts)
        @fonts = fonts
      end

      def audit_font_dependencies
        fonts.each do |font|
          if self.class.__send__(:local_files_present?, font[:files].values)
            fonts.delete(font)
          end
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
          self.class.__send__(:download_font_file, font[:location])
          extract_fonts(font)
        end
      rescue NetworkConnectionError
        false
      end

      private

      def extract_fonts(font)
        require "zip"
        self.class.__send__(:extract_fonts, font)
      end
    end
  end
end
