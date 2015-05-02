require_relative '../../resume_generator'
require 'optparse'
require 'forwardable'

module ResumeGenerator
  module CLI
    class ArgumentParser
      extend Forwardable

      attr_reader :supported_locales, :parser
      attr_accessor :locale

      def initialize
        @locale = :en
        @supported_locales = [:en, :ja]
        @parser = initialize_parser
      end

      def_delegator :@parser, :parse!

      private

      def initialize_parser
        OptionParser.new do |opts|
          opts.banner = 'Usage: ./bin/resume [options]'
          opts.separator ''
          opts.separator 'Specific options:'

          opts.on('-l', '--locale LOCALE',
                  'Select the locale of the resume') do |locale|
            locale = locale.to_sym
            if supported_locales.include?(locale)
              self.locale = locale
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
        end
      end
    end
  end
end

