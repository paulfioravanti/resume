module Resume
  module CLI
    class DependencyInstallationError < StandardError
      attr_reader :messages

      def initialize(key)
        @messages = { error: key }
      end
    end
  end
end
