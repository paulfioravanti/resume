require_relative 'pdf_entry_files'

module OneSheet
  class PDFFiles
    include Readable

    attr_accessor :content
    attr_reader :path, :files1, :files2

    def self.read
      new.read
    end

    def initialize
      @content = ''
      @path = 'lib/resume/pdf/'
      @files1 = FILES[:pdf_files1]
      @files2 = FILES[:pdf_files2]
    end

    private_class_method :new

    def read
      files1.each do |file, from_line, to_line|
        content << read_file(path, file, from_line, to_line)
      end
      content << Files.read("#{path}entry/", :pdf_entry_files)
      files2.each do |file, from_line, to_line|
        content << read_file(path, file, from_line, to_line)
      end
      content
    end
  end
end
