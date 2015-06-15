module OneSheet
  class PDFEntryFiles
    include Readable

    attr_accessor :content
    attr_reader :path, :files

    def self.read(path)
      new(path).read
    end

    def initialize(path)
      @content = ''
      @path = "#{path}entry/"
      @files = initialize_files
    end

    private_class_method :new

    def read
      files.each do |file, from_line, to_line|
        read_file(path, file, from_line, to_line)
      end
      content
    end

    private

    def initialize_files
      [
        ['heading', 2, -4],
        ['header', 3, -4],
        ['company_logo', 3, -4],
        ['content', 6, -3]
      ]
    end
  end
end
