require 'open-uri'
require 'socket'
require_relative '../network_connection_error'

module Resume
  module PDF
    class FileFetcher

      def self.fetch(file)
        new(file).fetch
      end

      private_class_method :new

      def initialize(file)
        @file = file
      end

      def fetch
        open(file)
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      private

      attr_reader :file
    end
  end
end
