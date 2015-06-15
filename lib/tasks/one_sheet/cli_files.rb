module OneSheet
  class CLIFiles
    # include Readable

    attr_reader :path, :files

    def self.read
      new.read
    end

    def initialize
      @path = 'lib/resume/cli/'
      @files = FILES[:cli_files]
    end

    def read_file(path, file, from_line, to_line, line_break = "\n")
      lines = File.readlines("#{path}#{file}.rb")
      lines[from_line..to_line].join << line_break
    end

    private_class_method :new

    def read
      files.reduce('') do |content, file, range|
        content << read_file(path, *file)
      end
    end
  end
end
