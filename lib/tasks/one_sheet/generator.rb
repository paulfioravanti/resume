require_relative '../../resume/output'
require_relative 'files'
require 'yaml'

module OneSheet
  class Generator

    attr_accessor :content
    attr_reader :config, :file_types

    def self.run
      new.run
    end

    private_class_method :new

    def initialize
      @config = YAML.load_file(File.join(__dir__, 'config.yml'))
      @file_types = config[:file_types]
      @content = ''
    end

    def run
      resume_files
      start_app
      output_file
      run_specs
    end

    private

    def resume_files
      file_types.each do |type|
        content << Files.read(config[type])
      end
    end

    def start_app
      content <<
        "if __FILE__ == $0\n"\
        "  Resume.generate\n"\
        "end\n"
    end

    def output_file
      File.open('resume.rb', 'w') do |file|
        file.write(content)
      end
      Resume::Output.raw_success('Successfully generated one-sheet resume')
    end

    def run_specs
      Resume::Output.raw_warning('Running specs...')
      system('rspec', 'resume.rb')
    end
  end
end
