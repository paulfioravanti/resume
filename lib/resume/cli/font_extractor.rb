require_relative "file_system"

module Resume
  module CLI
    # Module concerned with extracting font files from a zip file.
    #
    # @author Paul Fioravanti
    module FontExtractor
      module_function

      # Extract font files from a zip file and store them in the system
      # temp directory.
      #
      # @param font [Hash] The hash containing data about the font file.
      # @return [Hash] A hash containing data about the extracted font files.
      def extract(font)
        Zip::File.open(FileSystem.tmpfile_path(font[:filename])) do |file|
          extract_file(font, file)
        end
      end

      def extract_file(font, file)
        file.each do |entry|
          extract_entry(font[:files], entry)
        end
      end
      private_class_method :extract_file

      def extract_entry(files, entry)
        files.each_value do |filename|
          next unless entry.name.match?(filename)
          # `true` in the block ensures any existing files are overwritten
          entry.extract(FileSystem.tmpfile_path(filename)) { true }
          break
        end
      end
      private_class_method :extract_entry
    end
  end
end
