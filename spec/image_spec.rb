require 'spec_helper'

describe Image do
  describe '.for' do
    let(:resource) { 'background' }
    let(:image) { double('image') }

    before do
      allow(Image).to receive(:open).and_return(image)
    end

    it 'returns the image for a resource' do
      expect(Image.for(resource)).to equal(image)
    end
  end
end