require 'spec_helper'

describe Resume do

  describe 'constants' do
    let(:version) { Resume.const_get('VERSION') }
    it 'has a VERSION constant' do
      expect(version).to_not be_empty
    end
  end
end