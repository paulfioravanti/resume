require 'optparse'

module Resume
  module CLI
    class ArgumentParser
      attr_accessor :locale
      attr_reader :supported_locales

      def self.locale
        new.parse
      end

      private_class_method :new

      def initialize
        @supported_locales = [:en, :ja]
        @parser = initialize_parser
      end

      def parse
        parser.parse!(ARGV)
        locale || :en
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
                "(#{supported_locales.join(', ')})") do |locale|
          locale = locale.to_sym
          if supported_locales.include?(locale)
            self.locale = locale
          else
            raise LocaleNotSupportedError.new(locale, supported_locales)
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
