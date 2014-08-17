require 'colourable'

module ResumeGenerator
  module Messages
    include Colourable

    private

    def request_gem_installation
      print yellow(
        "May I please install version 1.0.0 of the 'Prawn'\n"\
        "Ruby gem to help me generate a PDF (Y/N)? "
      )
    end

    def thank_user_for_permission
      puts green('Thank you kindly :-)')
    end

    def inform_start_of_gem_installation
      puts 'Installing Prawn gem version 1.0.0...'
    end

    def inform_start_of_resume_generation
      puts "Generating PDF. This shouldn't take longer than a few seconds..."
    end

    def inform_of_failure_to_generate_resume
      puts red(
        "Sorry, I won't be able to generate a PDF without this\n"\
        "specific version of the Prawn gem.\n"\
        "Please ask me directly for a PDF copy of my resume."
      )
    end

    def inform_of_successful_resume_generation
      puts green('Resume generated successfully.')
    end

    def print_thank_you_message
      puts cyan(
        "Thanks for looking at my resume. "\
        "I hope to hear from you soon!"
      )
    end

    def request_to_open_resume
      print yellow 'Would you like me to open the resume for you (Y/N)? '
    end

    def request_user_to_open_document
      puts yellow(
        "Sorry, I can't figure out how to open the resume on\n"\
        "this computer. Please open it yourself."
      )
    end

    def inform_of_successful_gem_installation
      puts green('Prawn gem successfully installed.')
    end

    def inform_of_gem_installation_failure
      puts red(
        "Sorry, for some reason I wasn't able to install prawn.\n"\
        "Either try again or ask me directly for a PDF copy of "\
        "my resume."
      )
    end
  end
end