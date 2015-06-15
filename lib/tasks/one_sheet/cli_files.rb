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
      @files = FILES[:cli_files]
    end

    private_class_method :new

    def read
      files.each do |file, from_line, to_line|
        read_file(path, file, from_line, to_line)
      end
      content
    end
  end
end
