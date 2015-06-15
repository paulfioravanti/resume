module OneSheet
  class Files
    include Readable

    attr_reader :path, :files

    def self.read(type)
      new(type).read
    end

    def initialize(type)
      file_type = FILES[type]
      @files = file_type[:files]
      @path = file_type[:path]
    end

    private_class_method :new

    def read
      files.reduce('') do |content, file|
        content << read_file(path, *file)
      end
    end
  end
end
