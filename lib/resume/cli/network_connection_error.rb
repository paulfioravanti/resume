module Resume
  module CLI
    class NetworkConnectionError < StandardError
      attr_reader :error_message, :warning_message

      def initialize
        @error_message =
          I18n.t('inform_of_inability_to_get_outside_connection')
        @warning_message =
          I18n.t('request_user_to_check_internet_settings')
      end
    end
  end
end
