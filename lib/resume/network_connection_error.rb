module Resume
  class NetworkConnectionError < StandardError
    attr_reader :messages

    def initialize
      @messages = {
        error: :cant_connect_to_the_internet,
        warning: :please_check_your_network_settings
      }
    end
  end
end
