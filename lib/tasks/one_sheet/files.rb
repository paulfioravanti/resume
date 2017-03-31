module OneSheet
  # Module concerned with reading in ranges of lines from files
  # that will constitute the one sheet resume.
  #
  # @author Paul Fioravanti
  module Files
    module_function

    # Reads in a range of lines of files of a particular type
    # and returns them as a string.
    #
    # @param type [Hash]
    #   a hash of values representing a set of line ranges of files to read in.
    # @return [String]
    #   the combined content of the set of line ranges of the files.
    def read(type)
      files, path = type.values_at(:files, :path)
      files.reduce("") do |content, file|
        content << read_file(path, file)
      end
    end

    def read_file(path, file)
      lines = File.readlines(File.join(path, file[:file]))
      lines[file[:from_line]..file[:to_line]].join << "\n"
    end
    private_class_method :read_file
  end
end
