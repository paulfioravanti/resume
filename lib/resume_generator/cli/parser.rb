require_relative '../../resume_generator'
require 'optparse'

module ResumeGenerator
  module CLI
    class Parser
      SUPPORTED_LOCALES = [:en, :ja]

      def self.parse!(args)
        opt_parser = OptionParser.new do |opts|
          opts.banner = 'Usage: ./bin/resume [options]'
          opts.separator ''
          opts.separator 'Specific options:'

          opts.on('-l', '--locale LOCALE',
                  'Select the locale of the resume') do |locale|
            locale = locale.to_sym
            if SUPPORTED_LOCALES.include?(locale)
              ResumeGenerator.locale = locale
            else
              puts "Locale '#{locale}' is not supported.\n"\
                   "Supported locales are: #{SUPPORTED_LOCALES.join(', ')}"
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
        unless ResumeGenerator.instance_variable_defined?(:@locale)
          ResumeGenerator.locale = :en
        end
        opt_parser.parse!(args)
      end
    end
  end
end

