require 'resume/file_downloader'

module Resume
  RSpec.describe FileDownloader do
    describe '.download' do
      let(:file) { 'filename' }
      let(:location) { 'https://www.example.com/files' }
      let(:mode) { 'w' }
      let(:file_filepath) { "/tmp/#{file}" }
      let(:local_file) { double('local_file') }
      let(:uri) { double('uri').as_null_object }

      before do
        allow(FileSystem).to \
          receive(:tmp_filepath).with(file).and_return(file_filepath)
        allow(File).to \
          receive(:open).with(file_filepath, mode).and_yield(local_file)
        allow(FileFetcher).to \
          receive(:fetch).with(location).and_yield(uri)
      end

      it 'downloads a file and saves it to a local location' do
        expect(local_file).to receive(:write).with(uri)
        described_class.download(file, location, mode)
      end
    end
  end
end
