require 'resume/decoder'

module Resume
  RSpec.describe Decoder do
    let(:encoded_string) { '3|\|c0D3d 1N|=0' }
    let(:decoded_string) { 'Encoded info' }

    before do
      allow(Base64).to \
        receive(:strict_decode64).with(encoded_string).
          and_return(decoded_string)
    end

    describe '.decode' do
      it 'strictly decodes the string, forcing UTF-8 encoding' do
        expect(decoded_string).to receive(:force_encoding).with('utf-8')
        described_class.decode(encoded_string)
      end
    end

    describe '.d' do
      it 'strictly decodes the string, forcing UTF-8 encoding' do
        expect(decoded_string).to receive(:force_encoding).with('utf-8')
        described_class.d(encoded_string)
      end
    end
  end
end
