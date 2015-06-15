module OneSheet
  class PDFEntryFiles
    include Readable

    attr_reader :path, :files

    def self.read(path)
      new(path).read
    end

    def initialize(path)
      @path = "#{path}entry/"
      @files = FILES[:pdf_entry_files]
    end

    private_class_method :new

    def read
      files.reduce('') do |content, file|
        content << read_file(path, *file)
      end
    end
  end
end
