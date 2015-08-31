require_relative 'file_system'
require_relative 'file_fetcher'

module Resume
  class FileDownloader
    def self.download(filename, location, mode)
      new(filename, location, mode).download
    end

    private_class_method :new

    def initialize(filename, location, mode)
      @filename = filename
      @location = location
      @mode = mode
    end

    def download
      File.open(FileSystem.tmp_filepath(filename), mode) do |file|
        FileFetcher.fetch(location) do |uri|
          file.write(uri.read)
        end
      end
    end

    private

    attr_reader :filename, :location, :mode
  end
end
