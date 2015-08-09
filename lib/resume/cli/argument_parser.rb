require 'optparse'
require_relative 'argument_error'

module Resume
  module CLI
    class ArgumentParser
      def self.parse
        # The parser is looks for the locale and determines whether
        # it's valid or not, so it can also be responsible for setting
        # the available locales for the app.
        I18n.available_locales = [:en, :ja]
        new.parse
      end

      private_class_method :new

      def initialize
        @parser = initialize_parser
      end

      def parse
        parser.parse!(ARGV)
      rescue OptionParser::InvalidOption
        raise InvalidOptionError.new(parser.help)
      rescue OptionParser::MissingArgument
        raise MissingArgumentError.new(parser.help)
      end

      private

      attr_reader :parser

      def initialize_parser
        OptionParser.new do |opts|
          opts.banner = 'Usage: ./bin/resume [options]'
          opts.separator ''
          opts.separator 'Specific options:'

          locale_option(opts)

          opts.separator ''
          opts.separator 'Common options:'

          help_option(opts)
          version_option(opts)
        end
      end

      def locale_option(opts)
        opts.on('-l', '--locale LOCALE',
                "Select the locale of the resume "\
                "(#{I18n.available_locales.join(', ')})") do |locale|
          locale = locale.to_sym
          if I18n.available_locales.include?(locale)
            I18n.locale = locale
          else
            raise LocaleNotSupportedError.new(locale)
          end
        end
      end

      def help_option(opts)
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end

      def version_option(opts)
        opts.on_tail('-v', '--version', 'Show version') do
          puts Resume::VERSION
          exit
        end
      end
    end
  end
end
