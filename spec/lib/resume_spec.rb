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
end
