describe Resource do
  describe '.for' do
    let(:image) { double('image') }
    let(:link) { double('link') }
    let(:name) { 'email' }
    let(:resource) { Resource.for(name) }

    before do
      allow(Image).to receive(:for).with(name.to_sym).and_return(image)
      allow(Link).to receive(:for).with(name.to_sym).and_return(link)
    end

    it 'has an image' do
      expect(resource.image).to equal(image)
    end

    it 'has a link' do
      expect(resource.link).to equal(link)
    end
  end
end
