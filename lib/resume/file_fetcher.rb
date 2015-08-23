require 'open-uri'
require 'socket'
require_relative 'network_connection_error'

module Resume
  class FileFetcher

    def self.fetch(file, &block)
      new(file, &block).fetch
    end

    private_class_method :new

    def initialize(file, &block)
      @file = file
      @block = block
    end

    def fetch
      # Specifically uses Kernel here in order to allow it to determine
      # the return file type: for this resume, it could be File, TempFile,
      # or StringIO
      Kernel.open(file, &block)
    rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
      raise NetworkConnectionError
    end

    private

    attr_reader :file, :block
  end
end
