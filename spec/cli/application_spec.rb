require 'spec_helper'
require 'resume_generator/cli/application'

RSpec.describe ResumeGenerator::CLI::Application do

  describe '.start' do
    let(:locale) { :en }
    let(:argument_parser) { double('argument_parser', locale: locale) }
    let(:application) { double('application') }

    before do
      # We don't need to parse any arguments; just hand the locale
      # straight to the application
      allow(argument_parser).to receive(:parse!)
    end

    it 'creates a new Application, passing in the locale, and calls #start' do
      expect(ResumeGenerator::CLI::Application).to \
        receive(:new).with(locale).and_return(application)
      expect(application).to receive(:start)
      ResumeGenerator::CLI::Application.start
    end
  end

  describe '#start' do
    let(:application) { described_class.new(:en) }

    context 'user has the required gems installed' do
      specify 'user is not asked to install any gems' do
        application
      end
    end

    context 'user does not have the required gems installed' do
      specify 'user is asked to install the required gems' do
      end

      context 'user agrees to install the gems' do
        it 'attempts to install the gems, and continues resume generation' do
        end
      end

      context 'when user does not agree to install the gems' do
        it 'informs the user it cannot generate the resume and exits' do
        end
      end
    end
  end

  describe 'generating the PDF' do
    before do
      # allow(cli).to receive(:gem).with('prawn', PRAWN_VERSION)
      # allow(cli).to receive(:gem).with('prawn-table', PRAWN_TABLE_VERSION)
      # allow(cli).to receive(:require).with('prawn')
      # allow(cli).to receive(:require).with('prawn/table')
    end

    it 'tells the PDF to generate itself' do
      # expect(cli).to \
      #   receive(:inform_start_of_resume_generation).and_call_original
      # expect(Resume).to receive(:generate)
      # cli.send(:generate_resume)
    end
  end

  describe 'post-PDF generation' do
    # let(:resume) { double('resume') }
    # let(:encoded_filename) { 'Encoded Document Name' }
    # let(:decoded_filename) { 'Decoded Document Name' }

    before do
      # allow(Resume).to receive(:resume).and_return(resume)
      # allow(resume).to \
      #   receive(:[]).with(:document_name).and_return(encoded_filename)
      # allow(cli).to \
      #   receive(:d).with(encoded_filename).and_return(decoded_filename)
    end

    it 'shows a success message and asks to open the resume' do
      # expect(cli).to receive(:inform_of_successful_resume_generation)
      # expect(cli).to receive(:request_to_open_resume)
      # cli.send(:clean_up)
    end

    context 'user allows the script to open the PDF' do
      # let(:document_name) { 'Decoded Document Name' }

      before do
        # allow(cli).to \
        #   receive(:d).with(ResumeGenerator::Resume::DOCUMENT_NAME).
        #     and_return(document_name)
        # allow(cli).to receive(:permission_granted?).and_return(true)
      end

      it 'attempts to open the document' do
        # expect(cli).to receive(:open_document)
        # expect(cli).to receive(:print_thank_you_message)
        # cli.send(:clean_up)
      end

      context 'user is on a mac' do
        # before { stub_const('RUBY_PLATFORM', 'darwin') }

        it 'opens the file using the open command' do
          # expect(cli).to \
          #   receive(:system).with("open #{document_name}.pdf")
          # cli.send(:clean_up)
        end
      end

      context 'user is on linux' do
        # before { stub_const('RUBY_PLATFORM', 'linux') }

        it 'opens the file using the xdg-open command' do
        #   expect(cli).to \
        #     receive(:system).with("xdg-open #{document_name}.pdf")
        #   cli.send(:clean_up)
        end
      end

      context 'user is on windows' do
        # before { stub_const('RUBY_PLATFORM', 'windows') }

        it 'opens the file using the cmd command' do
        #   expect(cli).to \
        #     receive(:system).
        #       with("cmd /c \"start #{document_name}.pdf\"")
        #   cli.send(:clean_up)
        end
      end

      context 'user is on an unknown operating system' do
        # before { stub_const('RUBY_PLATFORM', 'unknown') }

        it 'prints a message telling the user to open the file' do
        #   expect(cli).to \
        #     receive(:request_user_to_open_document).and_call_original
        #   cli.send(:clean_up)
        end
      end
    end

    context 'user does not allow script to open PDF' do
      # before { allow(cli).to receive(:permission_granted?).and_return(false) }

      it 'does not attempt to open the document' do
      #   expect(cli).to_not receive(:open_document)
      #   expect(cli).to receive(:print_thank_you_message)
      #   cli.send(:clean_up)
      end
    end
  end
end
