describe Link do
  describe '.for' do
    let(:resources) do
      [
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
    let(:decoded_email) { double('decoded_email') }

    before do
      allow(Link).to receive(:d).and_return(decoded_email)
    end

    it 'returns the link for a resource' do
      resources.each do |resource|
        expect(Link.for(resource)).to equal(decoded_email)
      end
    end
  end
end
