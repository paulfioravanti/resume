require "tmpdir"
require_relative "../output"
require_relative "exceptions"
require_relative "file_system"
require_relative "file_fetcher"
require_relative "content_parser"
require_relative "font_extractor"

module Resume
  module CLI
    # Module concerned with downloading font files to be used with
    # the Japanese language version of the resume.
    #
    # @author Paul Fioravanti
    class FontDownloader
      extend Forwardable

      # @!attribute fonts [r]
      # @return [Hash] The hash of fonts to download.
      attr_reader :fonts

      def self.local_files_present?(files)
        files.all? { |file| File.file?(FileSystem.tmpfile_path(file)) }
      end
      private_class_method :local_files_present?

      # Initialises a new instance of a Font Downloader.
      #
      # @param fonts [Hash]
      #   A hash containing the font file dependencies for the resume.
      # @return [FontDownloader]
      #   The font downloader object.
      def initialize(fonts)
        @fonts = fonts
      end

      # Audits the local system to see if the necessary font files
      # are available to use.
      #
      # @return [Hash] The list of remaining font files to install.
      def audit_font_dependencies
        fonts.each do |font|
          if self.class.__send__(:local_files_present?, font[:files].values)
            fonts.delete(font)
          end
        end
      end

      # Outputs a message indicating that a font file must be downloaded
      # in order to generate the resume.
      #
      # @return [nil]
      def output_font_dependencies
        return if fonts.none?

        Output.warning(:custom_fonts)
      end

      # Attempts to download the font file and reports back on
      # whether it was successful.
      #
      # @raise [NetworkConnectionError]
      #   if an internet connection is unavailable to download the file.
      # @return [true]
      #   if the font file was successfully downloaded.
      # @return [false]
      #   if the font file was not successfuly downloaded.
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
