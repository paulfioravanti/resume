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
      expect(described_class).to \
        receive(:new).with(locale).and_return(application)
      expect(application).to receive(:start)
      described_class.start
    end

    context 'user has the required gems installed' do
      before do
        # allow(cli).to receive(:gem).with('prawn', PRAWN_VERSION)
        # allow(cli).to receive(:gem).with('prawn-table', PRAWN_TABLE_VERSION)
        # allow(cli).to receive(:require).with('prawn')
        # allow(cli).to receive(:require).with('prawn/table')
      end

      it 'does not ask the user to install any gems' do

      end

      it 'informs the user that it will generate the resume' do

      end

      it 'generates the resume' do

      end

      it 'informs the user that the resume has been generated' do

      end

      it 'asks the user to open the resume' do

      end

      context 'user grants permission to open the resume' do
        it 'opens the document and thanks the user' do

        end
      end

      context 'user does not grant permission to open the resume' do
        it 'does not open the document and thanks the user' do

        end
      end
    end

    context 'user does not have the required gems installed' do
      specify 'user is asked to install the required gems' do
      end

      context 'user agrees to install the gems' do
        it 'attempts to install the gems, and continues resume generation' do
        end
      end

      context 'user does not agree to install the gems' do
        it 'informs the user it cannot generate the resume and exits' do
        end
      end
    end
  end
end
