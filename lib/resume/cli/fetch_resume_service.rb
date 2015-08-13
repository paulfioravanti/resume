require_relative 'network_connection_error'

module Resume
  module CLI
    class FetchResumeService

      def self.fetch_resume
        new.fetch_resume
      end

      private_class_method :new

      def fetch_resume
        I18n.t('inform_of_resume_information_gathering')
        JSON.parse(open(filename).read, symbolize_names: true)
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      private

      def filename
        I18n.t('resume_filename')
      end
    end
  end
end
