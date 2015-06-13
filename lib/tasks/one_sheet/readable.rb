module OneSheet
  module Readable
    def read_file(path, file, from_line, to_line, line_break = "\n")
      lines = File.readlines("#{path}#{file}.rb")
      content << lines[from_line..to_line].join << line_break
    end
  end
end
