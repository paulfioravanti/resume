require_relative "../../resume/output"
require_relative "files"
require "yaml"

module OneSheet
  module Generator
    module_function

    def run
      Resume::Output.raw_warning("Generating one-sheet resume...")
      resume = document_content << executable
      output_file(resume)
      run_specs
    end

    def document_content
      config = YAML.load_file(File.join(__dir__, "config.yml"))
      config.keys.reduce("") do |content, file_type|
        content << Files.read(config[file_type])
      end
    end
    private_class_method :document_content

    def executable
      <<~EXECUTABLE
        if __FILE__ == $0
          Resume.generate
        end
      EXECUTABLE
    end
    private_class_method :executable

    def output_file(resume)
      File.open("resume.rb", "w") do |file|
        file.write(resume)
      end
      Resume::Output.raw_success("Successfully generated one-sheet resume")
    end
    private_class_method :output_file

    def run_specs
      Resume::Output.raw_warning("Running specs...")
      system("bin/rspec", "resume.rb")
    end
    private_class_method :run_specs
  end
end
