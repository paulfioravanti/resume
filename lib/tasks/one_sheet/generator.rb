require_relative "../../resume/output"
require_relative "files"
require "yaml"

module OneSheet
  # Entry point for the `rake resume` task to
  # generate the one-sheet resume.
  #
  # @author Paul Fioravanti
  module Generator
    CONFIG = YAML.load_file(File.join(__dir__, "config.yml"))
    private_constant :CONFIG

    module_function

    # Runs the generator for the one-sheet resume.
    #
    # - Compiles the contents of all the resume Ruby files
    # - Outputs it as a single `resume.rb` Ruby file
    # - Runs the specs on the file
    # - Runs quality checks on the file
    #
    # @return [true, nil]
    #   true if everything runs correctly, and nil if something fails
    def run
      Resume::Output.raw_warning("Generating one-sheet resume...")
      resume = document_content << executable
      output_file(resume)
      run_specs
      run_code_quality_check
    end

    def document_content
      CONFIG.keys.reduce("") do |content, file_type|
        content << Files.read(CONFIG[file_type])
      end
    end
    private_class_method :document_content

    def executable
      <<~EXECUTABLE
        if __FILE__ == $PROGRAM_NAME
          Resume.generate
        end
      EXECUTABLE
    end
    private_class_method :executable

    def output_file(resume)
      # NOTE: When generated on Windows, the file will have have CRLF
      # line endings, which will trip up Rubocop's Style/EndOfLine cop.
      # This is unavoidable, so just ignore the warning when rubocop
      # runs on the generated file.
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

    def run_code_quality_check
      Resume::Output.raw_warning("Running code quality check...")
      system(
        "rubocop",
        "--display-cop-names",
        "--format",
        "fuubar",
        "resume.rb"
      )
    end
    private_class_method :run_code_quality_check
  end
end
