require_relative 'network_connection_error'

module Resume
  module CLI
    class FetchResumeService

      def self.fetch_resume
        new.fetch_resume
      end

      private_class_method :new

      def fetch_resume
        Output.message(:gathering_resume_information)
        JSON.parse(
          open(Resume.filename).read,
          symbolize_names: true
        )
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end
    end
  end
end
