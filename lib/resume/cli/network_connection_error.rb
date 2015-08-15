module Resume
  module CLI
    class NetworkConnectionError < StandardError
      attr_reader :messages

      def initialize
        @messages = {
          error: :cant_get_an_outside_connection,
          warning: :please_check_your_internet_settings
        }
      end
    end
  end
end
