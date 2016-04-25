module OneSheet
  class Files
    extend Forwardable

    def self.read(type)
      new(type).read
    end

    def self.read_file(path, file)
      lines = File.readlines(File.join(path, file[:file]))
      lines[file[:from_line]..file[:to_line]].join << "\n"
    end
    private_class_method :read_file

    private_class_method :new

    def initialize(type)
      @files = type[:files]
      @path = type[:path]
    end

    def_delegator self, :read_file

    def read
      files.reduce('') do |content, file|
        content << read_file(path, file)
      end
    end

    private

    attr_reader :path, :files
  end
end
