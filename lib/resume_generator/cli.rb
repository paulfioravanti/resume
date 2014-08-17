$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'resume')
require 'colourable'
require 'resume'

module ResumeGenerator
  DOCUMENT_NAME = 'Resume'

  class CLI
    include Colourable

    def self.report(string)
      puts string
    end

    def start
      check_ability_to_generate_resume
      generate_resume
      clean_up
    end

    private

    def check_ability_to_generate_resume
      return if required_gem_available?('prawn', '1.0.0')
      request_gem_installation
      if permission_granted?
        thank_user_for_permission
        inform_start_of_gem_installation
        install_gem
      else
        inform_of_failure_to_generate_resume
        exit
      end
    end

    def generate_resume
      gem 'prawn', '1.0.0'
      require 'prawn'
      inform_start_of_resume_generation
      Resume.generate
    end

    def clean_up
      inform_of_sucessful_resume_generation
      request_to_open_resume
      open_document if permission_granted?
      print_thank_you_message
    end

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

    def inform_of_sucessful_resume_generation
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

    def open_document
      case RUBY_PLATFORM
      when %r(darwin)
        system("open #{DOCUMENT_NAME}.pdf")
      when %r(linux)
        system("xdg-open #{DOCUMENT_NAME}.pdf")
      when %r(windows)
        system("cmd /c \"start #{DOCUMENT_NAME}.pdf\"")
      else
        request_user_to_open_document
      end
    end

    def request_user_to_open_document
      puts yellow(
        "Sorry, I can't figure out how to open the resume on\n"\
        "this computer. Please open it yourself."
      )
    end

    def required_gem_available?(name, version)
      Gem::Specification.find_by_name(name).version >= Gem::Version.new(version)
    rescue Gem::LoadError # gem not installed
      false
    end

    def permission_granted?
      gets.chomp.match(%r{\A(y|yes)\z}i)
    end

    def install_gem
      begin
        system('gem install prawn -v 1.0.0')
        inform_of_successful_gem_installation
        Gem.clear_paths # Reset the dir and path values so Prawn can be required
      rescue
        inform_of_gem_installation_failure
        exit
      end
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
