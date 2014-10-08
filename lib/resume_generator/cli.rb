$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'resume')
require 'messages'
require 'resume'

module ResumeGenerator
  DOCUMENT_NAME = 'UGF1bF9GaW9yYXZhbnRpX1Jlc3VtZQ=='
  PRAWN_VERSION = '1.2.1'
  PRAWN_TABLE_VERSION = '0.1.2'

  class CLI
    include Decodable, Messages

    def start
      check_ability_to_generate_resume
      generate_resume
      clean_up
    end

    private

    def check_ability_to_generate_resume
      return if required_gems_available?(
        'prawn' => PRAWN_VERSION, 'prawn-table' => PRAWN_TABLE_VERSION
      )
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
      gem 'prawn', PRAWN_VERSION
      gem 'prawn-table', PRAWN_TABLE_VERSION
      require 'prawn'
      require 'prawn/table'
      inform_start_of_resume_generation
      Resume.generate(self)
    end

    def clean_up
      inform_of_successful_resume_generation
      request_to_open_resume
      open_document if permission_granted?
      print_thank_you_message(d(DOCUMENT_NAME))
    end

    def open_document
      case RUBY_PLATFORM
      when %r(darwin)
        system("open #{d(DOCUMENT_NAME)}.pdf")
      when %r(linux)
        system("xdg-open #{d(DOCUMENT_NAME)}.pdf")
      when %r(windows)
        system("cmd /c \"start #{d(DOCUMENT_NAME)}.pdf\"")
      else
        request_user_to_open_document
      end
    end

    def required_gems_available?(gems)
      gems.each do |name, version|
        if Gem::Specification.find_by_name(name).version <
          Gem::Version.new(version)
          return false
        end
      end
      true
    rescue Gem::LoadError # gem not installed
      false
    end

    def permission_granted?
      gets.chomp.match(%r{\Ay(es)?\z}i)
    end

    def install_gem
      begin
        system("gem install prawn -v #{PRAWN_VERSION}")
        system("gem install prawn-table -v #{PRAWN_TABLE_VERSION}")
        inform_of_successful_gem_installation
        # Reset the dir and path values so Prawn can be required
        Gem.clear_paths
      rescue
        inform_of_gem_installation_failure
        exit
      end
    end
  end
end
