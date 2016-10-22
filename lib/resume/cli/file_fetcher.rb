require "open-uri"
require "socket"
require "tmpdir"
require "pathname"
require_relative "exceptions"
require_relative "file_system"

module Resume
  module CLI
    class FileFetcher
      def self.fetch(path, filename: "")
        pathname = Pathname.new(path)
        filename = pathname.basename.to_path if filename.empty?
        new(pathname, filename).fetch
      end

      private_class_method :new

      def initialize(pathname, filename)
        @pathname = pathname
        @filename = filename
      end

      def fetch
        local_file || tmpfile || remote_file
      end

      private

      attr_reader :pathname, :filename

      def local_file
        File.open(pathname) if pathname.file?
      end

      def tmpfile
        File.open(tmpfile_path) if tmpfile_path.file?
      end

      def remote_file
        File.open(tmpfile_path, "wb") do |file|
          Kernel.open(remote_file_path) do |uri|
            file.write(uri.read)
          end
        end
        tmpfile
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      def tmpfile_path
        @tmpfile_path ||= FileSystem.tmpfile_path(filename)
      end

      def remote_file_path
        path = pathname.to_path
        uri? ? path : File.join(REMOTE_REPO, path)
      end

      def uri?
        uri = URI.parse(pathname.to_path)
        %w(http https).include?(uri.scheme)
      rescue URI::BadURIError, URI::InvalidURIError
        false
      end
    end
  end
end
