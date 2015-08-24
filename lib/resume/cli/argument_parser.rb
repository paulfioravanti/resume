require 'optparse'
require_relative '../exceptions'

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
          I18n.t(:locale_switch_short),
          I18n.t(:locale_switch_long),
          I18n.t(:locale_switch_description)) do |locale|
          begin
            I18n.locale = locale.to_sym
          rescue I18n::InvalidLocale
            raise LocaleNotSupportedError, locale
          end
        end
      end

      def help_option(opts)
        opts.on_tail(
          I18n.t(:help_switch_short),
          I18n.t(:help_switch_long),
          I18n.t(:help_switch_description)) do
          Output.raw(opts)
          throw :halt
        end
      end

      def version_option(opts)
        opts.on_tail(
          I18n.t(:version_switch_short),
          I18n.t(:version_switch_long),
          I18n.t(:version_switch_description)) do
          Output.raw(Resume::VERSION)
          throw :halt
        end
      end
    end
  end
end
