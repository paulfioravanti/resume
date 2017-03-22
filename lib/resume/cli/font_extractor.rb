require_relative "file_system"

module Resume
  module CLI
    module FontExtractor
      module_function

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
        files.each do |_, filename|
          next unless entry.name.match(filename)
          # `true` in the block ensures any existing files are overwritten
          entry.extract(FileSystem.tmpfile_path(filename)) { true }
          break
        end
      end
      private_class_method :extract_entry
    end
  end
end
