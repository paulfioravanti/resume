require_relative '../../resume_generator'
require 'optparse'

module ResumeGenerator
  module CLI
    Parser = OptionParser.new do |opts|
      supported_locales = [:en, :ja]
      opts.banner = 'Usage: ./bin/resume [options]'
      opts.separator ''
      opts.separator 'Specific options:'

      opts.on('-l', '--locale LOCALE',
              'Select the locale of the resume') do |locale|
        locale = locale.to_sym
        if supported_locales.include?(locale)
          ResumeGenerator.locale = locale
        else
          puts "Locale '#{locale}' is not supported.\n"\
               "Supported locales are: #{supported_locales.join(', ')}"
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
      unless ResumeGenerator.instance_variable_defined?(:@locale)
        ResumeGenerator.locale = :en
      end
    end
  end
end

