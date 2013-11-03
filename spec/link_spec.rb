require 'spec_helper'

describe Link do
  describe '.for' do
    let(:resource) { 'email' }
    let(:decoded_email) { double('decoded_email') }

    before do
      allow(Link).to receive(:d).and_return(decoded_email)
    end

    it 'returns the link for a resource' do
      expect(Link.for(resource)).to equal(decoded_email)
    end
  end
end