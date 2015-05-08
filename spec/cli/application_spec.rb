require 'spec_helper'
require 'resume_generator/cli/application'

RSpec.describe ResumeGenerator::CLI::Application do
  let(:locale) { :en }

  before do
    allow($stdout).to receive(:write) # suppress message cruft from stdout
  end

  describe '.start' do
    let(:argument_parser) do
      double('argument_parser', parse!: true, locale: locale)
    end
    let(:application) { double('application') }

    before do
      stub_const(
        'ResumeGenerator::CLI::ArgumentParser',
        double('ArgumentParser', new: argument_parser)
      )
    end

    it 'creates a new Application, passing in the locale, and calls #start' do
      expect(described_class).to \
        receive(:new).with(locale).and_return(application)
      expect(application).to receive(:start)
      described_class.start
    end
  end

  describe '#start' do
    let(:application) { described_class.new(locale) }

    describe 'install gems' do
      let(:gem_installer) { double('gem_installer') }

      before do
        stub_const(
          'ResumeGenerator::CLI::GemInstaller',
          double('GemInstaller', new: gem_installer)
        )
      end

      context 'when required gems are already installed' do
        before do
          allow(gem_installer).to \
            receive(:installation_required?).and_return(false)
          allow(application).to receive(:generate_resume)
          allow(application).to receive(:open_resume)
        end

        it 'does not request to install any gems' do
          expect(application).to_not receive(:install_gems)
          application.start
        end
      end

      context 'when the required gems are not installed' do
        before do
          allow(gem_installer).to \
            receive(:installation_required?).and_return(true)
          expect(application).to \
            receive(:request_gem_installation).and_call_original
        end

        context 'when permission is granted to install the gems' do
          before do
            allow(application).to receive(:gets).and_return('yes')
            allow(application).to receive(:generate_resume)
            allow(application).to receive(:open_resume)
          end

          it 'attempts to install the gems' do
            expect(gem_installer).to receive(:install)
            application.start
          end
        end

        context 'when permission is not granted to install the gems' do
          let(:starting_the_application) { -> { application.start } }

          before do
            allow(application).to receive(:gets).and_return('no')
          end

          it 'informs the user it cannot generate the resume and exits' do
            expect(application).to \
              receive(:inform_of_failure_to_generate_resume).and_call_original
            expect(starting_the_application).to raise_error(SystemExit)
          end
        end
      end
    end

    describe 'generate resume' do
      let(:resume) { double('Resume::Document') }

      before do
        allow(application).to receive(:install_gems)
        stub_const('ResumeGenerator::Resume::Document', resume)
        allow(application).to receive(:open_resume)
      end

      it 'generates the resume' do
        expect(application).to \
          receive(:inform_start_of_resume_generation).and_call_original
        expect(resume).to receive(:generate).with(application)
        expect(application).to \
          receive(:inform_of_successful_resume_generation).and_call_original
        application.start
      end
    end

    describe 'open resume' do
      let(:file_system) { double('FileSystem') }

      before do
        stub_const('ResumeGenerator::CLI::FileSystem', file_system)
        allow(application).to receive(:install_gems)
        allow(application).to receive(:generate_resume)
        expect(application).to \
          receive(:request_to_open_resume).and_call_original
      end

      context 'when permission is granted to open the resume' do
        before do
          allow(application).to receive(:gets).and_return('yes')
        end

        it 'attempts to open the resume and thanks the reader' do
          expect(file_system).to receive(:open_document).with(application)
          expect(application).to \
            receive(:print_thank_you_message).and_call_original
          application.start
        end
      end

      context 'when permission is not granted to open the resume' do
        before do
          allow(application).to receive(:gets).and_return('no')
        end

        it 'does not open the resume and thanks the reader' do
          expect(file_system).to_not receive(:open_document)
          expect(application).to \
            receive(:print_thank_you_message).and_call_original
          application.start
        end
      end
    end
  end
end
