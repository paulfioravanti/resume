require 'open-uri'
require 'json'
require 'socket'
require_relative '../network_connection_error'

module Resume
  module CLI
    class ResumeDataFetcher

      def self.fetch
        new.fetch
      end

      private_class_method :new

      def fetch
        Output.plain(:gathering_resume_information)
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
