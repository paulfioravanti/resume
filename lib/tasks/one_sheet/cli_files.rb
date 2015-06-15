module OneSheet
  class CLIFiles
    include Readable

    attr_reader :path, :files
    attr_accessor :content

    def self.read
      new.read
    end

    def initialize
      @content = ''
      @path = 'lib/resume/cli/'
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
        ['colours', 1, -3],
        ['messages', 4, -3],
        ['argument_parser', 6, -3],
        ['gem_installer', 2, -3],
        ['file_system', 2, -3],
        ['application', 8, -2]
      ]
    end
  end
end
