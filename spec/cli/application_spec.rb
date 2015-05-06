require 'spec_helper'
require 'resume_generator/cli/application'

RSpec.describe ResumeGenerator::CLI::Application do
  let(:locale) { :en }

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
            receive(:required_gems_available?).and_return(true)
          allow(application).to receive(:generate_resume)
          allow(application).to receive(:open_resume)
        end

        it 'does not request to install any gems' do
          expect(application).to_not receive(:request_gem_installation)
          application.start
        end
      end

      context 'when the required gems are not installed' do
        before do
          allow(gem_installer).to \
            receive(:required_gems_available?).and_return(false)
          expect(application).to receive(:request_gem_installation)
        end

        context 'when permission is granted to install the gems' do
          before do
            allow(application).to receive(:gets).and_return('yes')
            allow(application).to receive(:generate_resume)
            allow(application).to receive(:open_resume)
          end

          it 'attempts to install the gems' do
            expect(application).to receive(:thank_user_for_permission)
            expect(application).to receive(:inform_start_of_gem_installation)
            expect(gem_installer).to receive(:install_gems)
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
              receive(:inform_of_failure_to_generate_resume)
            expect(starting_the_application).to raise_error(SystemExit)
          end
        end
      end
    end

    describe 'generate resume' do
      let(:resume) { double('Resume::Document') }

      before do
        stub_const('ResumeGenerator::Resume::Document', resume)
        allow(application).to receive(:install_gems)
        allow(application).to \
          receive(:gem).with('prawn', ResumeGenerator::PRAWN_VERSION)
        allow(application).to receive(:gem).
          with('prawn-table', ResumeGenerator::PRAWN_TABLE_VERSION)
        allow(application).to receive(:require).with('prawn')
        allow(application).to receive(:require).with('prawn/table')
        allow(application).to receive(:open_resume)
      end

      it 'generates the resume' do
        expect(application).to \
          receive(:inform_start_of_resume_generation)
        expect(resume).to receive(:generate).with(application)
        expect(application).to \
          receive(:inform_of_successful_resume_generation)
        application.start
      end
    end

    describe 'open resume' do
      let(:file_system) { double('FileSystem') }

      before do
        stub_const('ResumeGenerator::CLI::FileSystem', file_system)
        allow(application).to receive(:install_gems)
        allow(application).to receive(:generate_resume)
        expect(application).to receive(:request_to_open_resume)
      end

      context 'when permission is granted to open the resume' do
        before do
          allow(application).to receive(:gets).and_return('yes')
        end

        it 'attempts to open the resume and thanks the reader' do
          expect(file_system).to receive(:open_document).with(application)
          expect(application).to receive(:print_thank_you_message)
          application.start
        end
      end

      context 'when permission is not granted to open the resume' do
        before do
          allow(application).to receive(:gets).and_return('no')
        end

        it 'does not open the resume and thanks the reader' do
          expect(file_system).to_not receive(:open_document)
          expect(application).to receive(:print_thank_you_message)
          application.start
        end
      end
    end
  end
end
