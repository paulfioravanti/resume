require 'spec_helper'
require 'resume'
require 'resume/cli/application'

RSpec.describe Resume do
  describe 'constants' do
    [:VERSION, :REMOTE_REPO, :REQUIRED_RUBY_VERSION].each do |const|
      context "for #{const}" do
        it 'is defined' do
          expect(described_class.const_defined?(const)).to be true
        end
      end
    end
  end

  describe '.generate' do
    context 'when attempting to run the app with an old Ruby version' do
      it 'requests the user to install the expected Ruby version' do

      end
    end

    context 'when a LoadError occurs when checking the Ruby version' do
      it 'requests the user to install the expected Ruby version' do

      end
    end

    context 'when running the app with the expected Ruby version' do
      it 'starts the CLI application' do
        expect(described_class::CLI::Application).to receive(:start)
        described_class.generate
      end
    end
  end
end
