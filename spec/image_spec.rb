require 'spec_helper'

describe Image do
  describe '.for' do
    let(:resources) do
      [
        'background',
        'email',
        'linked_in',
        'github',
        'stackoverflow',
        'speakerdeck',
        'vimeo',
        'code_school',
        'twitter',
        'blog',
        'rc',
        'ruby',
        'rails',
        'gw',
        'rnt',
        'sra',
        'jet',
        'satc',
        'mit',
        'bib',
        'ryu',
        'tafe'
      ]
    end
    let(:image) { double('image') }

    before do
      allow(Image).to receive(:open).and_return(image)
    end

    it 'returns the image for a resource' do
      resources.each do |resource|
        expect(Image.for(resource)).to equal(image)
      end
    end
  end
end