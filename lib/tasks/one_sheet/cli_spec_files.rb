module OneSheet
  class CLISpecFiles
    include Readable

    attr_reader :path, :files
    attr_accessor :content

    def self.read
      new.read
    end

    def initialize
      @content = ''
      @path = 'spec/lib/resume/cli/'
      initialize_files
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
      @files = [
        ['application_spec', 3, -1],
        ['argument_parser_spec', 3, -1],
        ['file_system_spec', 4, -1],
        ['gem_installer_spec', 4, -1]
      ]
    end
  end
end
