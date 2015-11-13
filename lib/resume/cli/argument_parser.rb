require 'optparse'
require_relative 'exceptions'

module Resume
  module CLI
    class ArgumentParser
      def self.parse
        new.parse
      end

      private_class_method :new

      def initialize
        @parser = initialize_parser
      end

      def parse
        parser.parse!(ARGV)
      rescue OptionParser::InvalidOption
        raise InvalidOptionError, parser.help
      rescue OptionParser::MissingArgument
        raise MissingArgumentError, parser.help
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
          begin
            I18n.locale = locale.to_sym
          rescue I18n::InvalidLocale
            raise LocaleNotSupportedError, locale
          end
        end
      end

      def help_option(opts)
        opts.on_tail('-h', '--help', 'Show this message') do
          Output.raw(opts)
          throw :halt
        end
      end

      def version_option(opts)
        opts.on_tail('-v', '--version', 'Show version') do
          Output.raw(Resume::VERSION)
          throw :halt
        end
      end
    end
  end
end
