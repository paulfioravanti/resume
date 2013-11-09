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
        'rc_location',
        'ruby',
        'rails',
        'fl_location',
        'gw',
        'gw_location',
        'rnt',
        'rnt_location',
        'sra',
        'sra_location',
        'jet',
        'jet_location',
        'satc',
        'satc_location',
        'mit',
        'mit_location',
        'bib',
        'bib_location',
        'ryu',
        'ryu_location',
        'tafe',
        'tafe_location'
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
