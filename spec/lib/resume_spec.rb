require 'spec_helper'
require 'resume'

RSpec.describe Resume do
  describe 'constants' do
    [:VERSION, :REMOTE_REPO].each do |const|
      context "for #{const}" do
        it 'is defined' do
          expect(described_class.const_defined?(const)).to be true
        end
      end
    end
  end

  describe '.generate' do
    it 'starts the CLI application' do
      expect(described_class::CLI::Application).to receive(:start)
      described_class.generate
    end
  end
end
