require 'spec_helper'
require 'resume_generator/cli/file_system'
require 'resume_generator/cli/application'

RSpec.describe ResumeGenerator::CLI::FileSystem do
  describe '.open_document' do
    let(:resume_name) { 'My Resume.pdf' }
    let(:app) { ResumeGenerator::CLI::Application.new(:en) }

    before do
      allow(app).to receive(:filename).and_return(resume_name)
      allow($stdout).to receive(:write) # suppress message cruft from stdout
    end

    context 'when run on Mac OS' do
      let(:mac_open_file_args) { ['open', app.filename] }

      before { stub_const('RUBY_PLATFORM', 'darwin') }

      it 'opens the file using the open command' do
        expect(described_class).to \
          receive(:system).with(*mac_open_file_args)
        described_class.open_document(app)
      end
    end

    context 'when run on Linux' do
      let(:linux_open_file_args) { ['xdg-open', app.filename] }

      before { stub_const('RUBY_PLATFORM', 'linux') }

      it 'opens the file using the xdg-open command' do
        expect(described_class).to \
          receive(:system).with(*linux_open_file_args)
        described_class.open_document(app)
      end
    end

    context 'when run on Windows' do
      let(:windows_open_file_args) do
        ['cmd', '/c', "\"start #{app.filename}\""]
      end

      before { stub_const('RUBY_PLATFORM', 'windows') }

      it 'opens the file using the cmd /c command' do
        expect(described_class).to \
          receive(:system).with(*windows_open_file_args)
        described_class.open_document(app)
      end
    end

    context 'when run on an unknown operating system' do
      before { stub_const('RUBY_PLATFORM', 'unknown') }

      it 'requests the user to open the document themself' do
        expect(app).to \
          receive(:request_user_to_open_document).and_call_original
        described_class.open_document(app)
      end
    end
  end
end
