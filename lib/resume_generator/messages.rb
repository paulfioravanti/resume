module ResumeGenerator
  module Messages
    include Colourable

    def inform_creation_of_social_media_links
      puts 'Creating social media links...'
    end

    def inform_creation_of_technical_skills
      puts 'Creating technical skills section...'
    end

    def inform_creation_of_employment_history
      puts 'Creating employment history section...'
    end

    def inform_creation_of_education_history
      puts 'Creating education history section...'
    end

    private

    def request_gem_installation
      print yellow(
        "May I please install the following Ruby gems:\n"\
        "- prawn 1.2.1\n"\
        "- prawn-table 0.1.0\n"\
        "in order to help me generate a PDF (Y/N)? "\
      )
    end

    def thank_user_for_permission
      puts green('Thank you kindly :-)')
    end

    def inform_start_of_gem_installation
      puts 'Installing required gems...'
    end

    def inform_start_of_resume_generation
      puts "Generating PDF. This shouldn't take longer than a few seconds..."
    end

    def inform_of_failure_to_generate_resume
      puts red(
        "Sorry, I won't be able to generate a PDF\n"\
        "without these specific gem versions.\n"\
        "Please ask me directly for a PDF copy of my resume."
      )
    end

    def inform_of_successful_resume_generation
      puts green('Resume generated successfully.')
    end

    def print_thank_you_message(document_name)
      puts cyan(
        "Thanks for looking at my resume. I hope to hear from you soon!\n"\
        "#{document_name}.pdf has been generated in the same\n"\
        "directory you ran the script."
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
      puts green('Gems successfully installed.')
    end

    def inform_of_gem_installation_failure
      puts red(
        "Sorry, for some reason I wasn't able to\n"\
        "install one or more required gems.\n"\
        "Either try again or ask me directly for a PDF copy of "\
        "my resume."
      )
    end
  end
end
