module Resume
  module CLI
    class DependencyInstallationError < ArgumentError
      attr_reader :messages

      def initialize(key)
        @messages = { error: key }
      end
    end
  end
end
