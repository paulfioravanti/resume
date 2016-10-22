module OneSheet
  module Files
    module_function

    def read(type)
      type[:files].reduce("") do |content, file|
        content << read_file(type[:path], file)
      end
    end

    def read_file(path, file)
      lines = File.readlines(File.join(path, file[:file]))
      lines[file[:from_line]..file[:to_line]].join << "\n"
    end
    private_class_method :read_file
  end
end
