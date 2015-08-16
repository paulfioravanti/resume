require_relative '../network_connection_error'

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
        Output.warning(:custom_fonts)
      end

      def fonts_successfully_downloaded?
        fonts.all? do |font|
          Output.plain([
            :downloading_font,
            { file_name: font[:file_name], location: font[:location] }
          ])
          download_font_file(font)
          extract_fonts(font)
        end
      end

      private

      def files_present?(files)
        files.all? { |file| File.exist?(tmp_filepath(file)) }
      end

      def download_font_file(font)
        open(tmp_filepath(font[:file_name]), 'wb') do |file|
          open(font[:location]) do |uri|
            file.write(uri.read)
          end
        end
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      def extract_fonts(font)
        require 'zip'
        Zip::File.open(tmp_filepath(font[:file_name])) do |file|
          file.each do |entry|
            font[:files].each do |_, file_name|
              if entry.name.match(file_name)
                # overwrite any existing files with true block
                entry.extract(tmp_filepath(file_name)) { true }
                break # inner loop only
              end
            end
          end
        end
      end

      def tmp_filepath(file)
        File.join(Dir.tmpdir, file)
      end
    end
  end
end
