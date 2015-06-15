module OneSheet
  class Files

    attr_reader :path, :files

    def self.read(type)
      new(type).read
    end

    def initialize(type)
      @files = type[:files]
      @path = type[:path]
    end

    private_class_method :new

    def read
      files.reduce('') do |content, file|
        content << read_file(*file)
      end
    end

    def read_file(file, from_line, to_line, line_break = "\n")
      lines = File.readlines("#{path}#{file}.rb")
      lines[from_line..to_line].join << line_break
    end
  end
end
