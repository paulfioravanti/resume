module OneSheet
  class Files

    attr_reader :path, :files

    def self.read(path, type)
      new(path, type).read
    end

    def initialize(path, type)
      @path = path
      @files = FILES[type]
    end

    private_class_method :new

    def read
      files.reduce('') do |content, file|
        content << read_file(path, *file)
      end
    end

    private

    def read_file(path, file, from_line, to_line, line_break = "\n")
      lines = File.readlines("#{path}#{file}.rb")
      lines[from_line..to_line].join << line_break
    end
  end
end
