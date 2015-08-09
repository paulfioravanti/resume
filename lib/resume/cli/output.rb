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
        output.public_methods(false).each do |method|
          send(method)
        end
      end

      private

      attr_reader :output

      def danger_message
        puts red(output.danger_message)
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
