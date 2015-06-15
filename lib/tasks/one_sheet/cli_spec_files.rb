module OneSheet
  class CLISpecFiles
    include Readable

    attr_reader :path, :files

    def self.read
      new.read
    end

    def initialize
      @path = 'spec/lib/resume/cli/'
      @files = FILES[:cli_spec_files]
    end

    private_class_method :new

    def read
      files.reduce('') do |content, file|
        content << read_file(path, *file)
      end
    end
  end
end
