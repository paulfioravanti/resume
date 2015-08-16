module Resume
  module CLI
    class DependencyInstallationError < ArgumentError
      attr_reader :messages

      def initialize(locale)
        @messages = {
          error: :dependency_installation_failed
        }
      end
    end
  end
end
