require "tmpdir"
require_relative "../output"
require_relative "exceptions"
require_relative "file_system"
require_relative "file_fetcher"
require_relative "content_parser"
require_relative "font_extractor"

module Resume
  module CLI
    class FontDownloader
      extend Forwardable

      attr_reader :fonts

      def self.local_files_present?(files)
        files.all? { |file| File.file?(FileSystem.tmpfile_path(file)) }
      end
      private_class_method :local_files_present?

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
          download_and_extract_font(font)
          true
        end
      rescue NetworkConnectionError
        false
      end

      private

      def download_and_extract_font(font)
        Output.plain(:downloading_font)
        FileFetcher.fetch(
          ContentParser.decode_content(font[:location])
        )
        require "zip"
        FontExtractor.extract(font)
      end
    end
  end
end
