module OneSheet
  class CLIFiles

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
  end
end
