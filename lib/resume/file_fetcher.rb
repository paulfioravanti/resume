require 'open-uri'
require 'socket'
require 'tmpdir'
require 'pathname'
require_relative 'exceptions'
require_relative 'file_system'

module Resume
  class FileFetcher
    REMOTE_REPO =
      # "https://raw.githubusercontent.com/paulfioravanti/resume/master"
      "https://raw.githubusercontent.com/paulfioravanti/resume/ja-resume-refactor"

    def self.fetch(path, filename: '', mode: 'w')
      pathname = Pathname.new(path)
      filename = pathname.basename.to_path if filename.empty?
      new(pathname, filename, mode).fetch
    end

    private_class_method :new

    def initialize(pathname, filename, mode)
      @pathname = pathname
      @filename = filename
      @mode = mode
    end

    def fetch
      local_file || tmpfile || remote_file
    end

    private

    attr_reader :pathname, :filename, :mode

    def local_file
      File.open(pathname) if pathname.file?
    end

    def tmpfile
      File.open(tmpfile_path) if tmpfile_path.file?
    end

    def remote_file
      File.open(tmpfile_path, mode) do |file|
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
      uri? ? pathname.to_path : File.join(REMOTE_REPO, pathname.to_path)
    end

    def uri?
      uri = URI.parse(pathname.to_path)
      %w(http https).include?(uri.scheme)
    rescue URI::BadURIError, URI::InvalidURIError
      false
    end
  end
end
