require 'optparse'
require_relative 'argument_error'

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
        raise InvalidOptionError.new(parser.help)
      rescue OptionParser::MissingArgument
        raise MissingArgumentError.new(parser.help)
      end

      private

      attr_reader :parser

      def initialize_parser
        OptionParser.new do |opts|
          opts.banner = I18n.t(:usage)
          opts.separator ''
          opts.separator I18n.t(:specific_options)

          locale_option(opts)

          opts.separator ''
          opts.separator I18n.t(:common_options)

          help_option(opts)
          version_option(opts)
        end
      end

      def locale_option(opts)
        opts.on(
          I18n.t(:locale_short_switch),
          I18n.t(:locale_long_switch),
          I18n.t(:locale_switch_description)) do |locale|
          begin
            I18n.locale = locale.to_sym
          rescue I18n::InvalidLocale
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
