$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'resume')
require 'optparse'
require 'messages'
require 'resume'

module ResumeGenerator
  PRAWN_VERSION = '2.0.0'
  PRAWN_TABLE_VERSION = '0.2.1'
  SUPPORTED_LANGUAGES = ['en', 'ja']

  def self.language
    @@language
  end

  def self.language=(language)
    @@language = language
  end

  class CLI
    include Decodable, Messages

    attr_reader :language

    def self.start(args)
      ResumeGenerator.language = 'en'
      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: ./bin/resume [options]'
        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-l', '--language LANGUAGE',
                'Select the language of the resume') do |language|
          if SUPPORTED_LANGUAGES.include?(language)
            ResumeGenerator.language = language
          else
            puts "Language '#{language}' is not supported.\n"\
              "Supported languages are: #{SUPPORTED_LANGUAGES.join(', ')}"
            exit
          end
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Show version') do
          puts ResumeGenerator::VERSION
          exit
        end
      end
      opt_parser.parse!(args)
      new.start
    end

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
      print_thank_you_message(d(Resume.resume[:document_name]))
    end

    def open_document
      case RUBY_PLATFORM
      when %r(darwin)
        system("open #{Resume.filename}")
      when %r(linux)
        system("xdg-open #{Resume.filename}")
      when %r(windows)
        system("cmd /c \"start #{Resume.filename}\"")
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
