require_relative 'colours'

module Resume
  module CLI
    class Output
      include Colours

      def self.message(output)
        new(output).message
      end

      private_class_method :new

      def initialize(output)
        @output = output
      end

      def message
        output.public_methods(false).each { |method| send(method) }
      end

      private

      attr_reader :output

      def error_message
        puts red(output.error_message)
      end

      def warning_message
        puts yellow(output.warning_message)
      end

      def info_message
        puts output.info_message
      end
    end
  end
end
