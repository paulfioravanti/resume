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
      @files1 = initialize_first_file_batch
      @files2 = initialize_second_file_batch
    end

    private_class_method :new

    def read
      files1.each do |file, from_line, to_line|
        read_file(path, file, from_line, to_line)
      end
      content << PDFEntryFiles.read(path)
      files2.each do |file, from_line, to_line|
        read_file(path, file, from_line, to_line)
      end
      content
    end

    private

    def initialize_first_file_batch
      [
        ['font', 1, -3],
        ['name', 2, -3],
        ['headline', 2, -3],
        ['transparent_link', 2, -3],
        ['logo', 2, -3],
        ['social_media_logo_set', 5, -3]
      ]
    end

    def initialize_second_file_batch
      [
        ['technical_skills', 4, -3],
        ['employment_history', 4, -3],
        ['education_history', 2, -3],
        ['manifest', 10, -3],
        ['options', 2, -3],
        ['document', 9, -1],
      ]
    end
  end
end
