$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "resume")
require 'colourable'
require 'resume/resume'

module Resume
  class CLI
    include Colourable

    def self.start
      new
    end

    def self.report(string)
      puts string
    end

    private

    def initialize
      check_ability_to_generate_resume
      generate_resume
      clean_up
    end

    def check_ability_to_generate_resume
      unless required_gem_available?('prawn', '1.0.0.rc2')
        print yellow "May I please install version 1.0.0.rc2 of the 'Prawn'\n"\
                     "Ruby gem to help me generate a PDF (Y/N)? "
        if permission_granted?
          install_gem
        else
          puts red "Sorry, I won't be able to generate a PDF without this\n"\
                   "specific version of the Prawn gem.\n"\
                   "Please ask me directly for a PDF copy of my resume."
          exit
        end
      end
      require 'prawn'
    end

    def generate_resume
      Resume.generate
    end

    def clean_up
      puts green 'Resume generated successfully.'
      print yellow 'Would you like me to open the resume for you (Y/N)? '
      open_document if permission_granted?
      puts cyan "Thanks for looking at my resume. "\
                "I hope to hear from you soon!"
    end

    def open_document
      case RUBY_PLATFORM
      when %r(darwin)
        %x(open #{DOCUMENT_NAME}.pdf)
      when %r(linux)
        %x(xdg-open #{DOCUMENT_NAME}.pdf)
      when %r(windows)
        %x(cmd /c "start #{DOCUMENT_NAME}.pdf")
      else
        puts yellow "Sorry, I can't figure out how to open the resume on\n"\
                    "this computer. Please open it yourself."
      end
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
      puts green 'Thank you kindly :-)'
      puts 'Installing Prawn gem version 1.0.0.rc2...'
      begin
        %x(gem install prawn -v 1.0.0.rc2)
      rescue
        puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
                 "Either try again or ask me directly for a PDF copy of "\
                 "my resume."
        exit
      end
      puts green 'Prawn gem successfully installed.'
      Gem.clear_paths # Reset the dir and path values so Prawn can be required
    end
  end
end