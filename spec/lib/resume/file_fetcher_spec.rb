require 'resume/file_fetcher'

module Resume
  RSpec.describe FileFetcher do
    describe '.fetch' do
      let(:file) { 'filename' }
      let(:block) { Proc.new { } }
      let(:fetching_file) do
        -> { described_class.fetch(file, &block) }
      end

      it 'opens up a StringIO to the file' do
        expect(Kernel).to receive(:open).with(file, &block)
        described_class.fetch(file, &block)
      end

      context 'when a socket error occurs' do
        before do
          allow(Kernel).to \
            receive(:open).with(file, &block).and_raise(SocketError)
        end

        it 'raises a NetworkConnectionError' do
          expect(fetching_file).to raise_error(NetworkConnectionError)
        end
      end

      context 'when a http error occurs' do
        before do
          allow(Kernel).to \
            receive(:open).with(file, &block).
              and_raise(OpenURI::HTTPError.new('some error', file))
        end

        it 'raises a NetworkConnectionError' do
          expect(fetching_file).to raise_error(NetworkConnectionError)
        end
      end

      context 'when a network connection error occurs' do
        before do
          allow(Kernel).to \
            receive(:open).with(file, &block).
              and_raise(Errno::ECONNREFUSED)
        end

        it 'raises a NetworkConnectionError' do
          expect(fetching_file).to raise_error(NetworkConnectionError)
        end
      end
    end
  end
end
