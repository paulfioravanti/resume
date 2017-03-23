require "open-uri"
require "socket"
require "tmpdir"
require "pathname"
require_relative "exceptions"
require_relative "file_system"

module Resume
  module CLI
    module FileFetcher
      REMOTE_REPO =
        "https://raw.githubusercontent.com/paulfioravanti/resume/master".freeze
      private_constant :REMOTE_REPO

      module_function

      def fetch(path, filename: "")
        pathname = Pathname.new(path)
        filename = pathname.basename.to_path if filename.empty?
        fetch_file(pathname, filename)
      end

      def fetch_file(pathname, filename)
        local_file(pathname) ||
          tmpfile(filename) ||
          remote_file(pathname, filename)
      end
      private_class_method :fetch_file

      def local_file(pathname)
        File.open(pathname) if pathname.file?
      end
      private_class_method :local_file

      def tmpfile(filename)
        tmpfile = tmpfile_path(filename)
        File.open(tmpfile) if tmpfile.file?
      end
      private_class_method :tmpfile

      def remote_file(pathname, filename)
        tmpfile = tmpfile_path(filename)
        File.open(tmpfile, "wb") do |file|
          write_file(file, pathname)
        end
        tmpfile
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end
      private_class_method :remote_file

      def tmpfile_path(filename)
        FileSystem.tmpfile_path(filename)
      end
      private_class_method :tmpfile_path

      def write_file(file, pathname)
        Kernel.open(remote_file_path(pathname)) do |uri|
          file.write(uri.read)
        end
      end
      private_class_method :write_file

      def remote_file_path(pathname)
        path = pathname.to_path
        uri?(pathname) ? path : File.join(REMOTE_REPO, path)
      end
      private_class_method :remote_file_path

      def uri?(pathname)
        uri = URI.parse(pathname.to_path)
        %w(http https).include?(uri.scheme)
      rescue URI::BadURIError, URI::InvalidURIError
        false
      end
      private_class_method :uri?
    end
  end
end
