require 'spec_helper'
require 'resume'

RSpec.describe Resume do
  describe 'constants' do
    let(:constant_defined) { described_class.const_defined?(const) }

    context 'for VERSION' do
      let(:const) { :VERSION }

      it 'is present' do
        expect(constant_defined).to be true
      end
    end

    context 'for DATA_LOCATION' do
      let(:const) { :DATA_LOCATION }

      it 'is present' do
        expect(constant_defined).to be true
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
