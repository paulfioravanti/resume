module OneSheet
  class Files

    def self.read(type)
      new(type).read
    end

    private_class_method :new

    def initialize(type)
      @files = type[:files]
      @path = type[:path]
    end

    def read
      files.reduce('') do |content, file|
        content << read_file(*file)
      end
    end

    private

    attr_reader :path, :files

    def read_file(file, from_line, to_line, line_break = "\n")
      lines = File.readlines(File.join(path, file))
      lines[from_line..to_line].join << line_break
    end
  end
end
