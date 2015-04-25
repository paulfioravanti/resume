require 'optparse'

module ResumeGenerator
  class CLIOptionParser
    SUPPORTED_LANGUAGES = [:en, :ja]

    def self.generate
      OptionParser.new do |opts|
        opts.banner = 'Usage: ./bin/resume [options]'
        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-l', '--language LANGUAGE',
                'Select the language of the resume') do |lang|
          language = lang.to_sym
          if SUPPORTED_LANGUAGES.include?(language)
            ResumeGenerator.language = language
          else
            puts "Language '#{lang}' is not supported.\n"\
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
    end
  end
end
