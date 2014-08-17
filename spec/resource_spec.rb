require 'spec_helper'

RSpec.describe Resource do
  describe '.for' do
    let(:image) { double('image') }
    let(:hash) do
      {
        image: "http://farm.staticflickr.com/example.jpg",
        link: "d3d3LmV4YW1wbGUuY29t",
        width: 35,
        height: 35,
        fit: [35, 35],
        align: "center",
        move_up: 35,
        bars: 3,
        size: 40,
        origin: 415,
        at: 280
      }
    end
    let(:resource) { Resource.for(hash) }

    before do
      allow(Resource).to receive(:open).with(hash[:image]).and_return(image)
    end

    it 'has an image' do
      expect(resource.image).to eq(image)
    end

    it 'has a link' do
      expect(resource.link).to eq('www.example.com')
    end

    it 'has a width' do
      expect(resource.width).to eq(35)
    end

    it 'has a height' do
      expect(resource.height).to eq(35)
    end

    it 'has a fit' do
      expect(resource.fit).to eq([35, 35])
    end

    it 'has an align' do
      expect(resource.align).to eq(:center)
    end

    it 'has a move_up' do
      expect(resource.move_up).to eq(35)
    end

    it 'has a bars' do
      expect(resource.bars).to eq(3)
    end

    it 'has a size' do
      expect(resource.size).to eq(40)
    end

    it 'has an origin' do
      expect(resource.origin).to eq(415)
    end

    it 'has an at ' do
      expect(resource.at).to eq(280)
    end
  end
end
