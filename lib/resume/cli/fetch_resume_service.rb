module Resume
  module CLI
    class NetworkConnectionError < StandardError
      def initialize(locale)

      end
    end

    class FetchResumeService
      def self.resume(locale)
        new(locale).resume
      end

      private_class_method :new

      def initialize(locale)
        @locale = locale
      end

      def resume
        I18n.t('inform_of_resume_information_gathering')
        JSON.parse(
          open("#{DATA_LOCATION}resume.#{locale}.json").read,
          symbolize_names: true
        )[:resume]
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError.new(locale)
      end

      private

      attr_reader :locale
    end
  end
end
