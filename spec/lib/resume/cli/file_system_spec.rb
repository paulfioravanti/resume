require 'spec_helper'
require 'resume/cli/file_system'

module Resume
  module CLI
    RSpec.describe FileSystem do
      describe '.open_document' do
        let(:filename) { 'resume.pdf' }

        context 'when run on Mac OS' do
          let(:mac_open_file_args) { ['open', filename] }

          before { stub_const('RUBY_PLATFORM', 'darwin') }

          it 'opens the file using the open command' do
            expect(described_class).to \
              receive(:system).with(*mac_open_file_args)
            described_class.open_document(filename)
          end
        end

        context 'when run on Linux' do
          let(:linux_open_file_args) { ['xdg-open', filename] }

          before { stub_const('RUBY_PLATFORM', 'linux') }

          it 'opens the file using the xdg-open command' do
            expect(described_class).to \
              receive(:system).with(*linux_open_file_args)
            described_class.open_document(filename)
          end
        end

        context 'when run on Windows' do
          let(:windows_open_file_args) do
            ['cmd', '/c', "\"start #{filename}\""]
          end

          before { stub_const('RUBY_PLATFORM', 'windows') }

          it 'opens the file using the cmd /c command' do
            expect(described_class).to \
              receive(:system).with(*windows_open_file_args)
            described_class.open_document(filename)
          end
        end

        context 'when run on an unknown operating system' do
          before { stub_const('RUBY_PLATFORM', 'unknown') }

          it 'requests the user to open the document themself' do
            expect(Output).to \
              receive(:warning).with(:dont_know_how_to_open_resume)
            described_class.open_document(filename)
          end
        end
      end

      describe '.tmpfile_path' do
        let(:filename) { 'file.txt' }
        let(:tmpdir) { '/tmp' }
        let(:pathname) { instance_double('Pathname') }

        before do
          allow(Dir).to receive(:tmpdir).and_return(tmpdir)
          allow(Pathname).to \
            receive(:new).with(tmpdir).and_return(pathname)
        end

        it 'returns the filepath for the file in system temp dir' do
          expect(pathname).to receive(:join).with(filename)
          described_class.tmpfile_path(filename)
        end
      end
    end
  end
end
