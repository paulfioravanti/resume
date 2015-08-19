require 'resume/decoder'

module Resume
  RSpec.describe Decoder do
    let(:decodable) do
      Class.new do
        include Decoder
        def self.decode_text(text); decode(text); end
        def self.d_text(text); d(text); end
        def decode_text(text); decode(text); end
        def d_text(text); d(text); end
      end
    end
    let(:encoded_string) { '3|\|c0D3d 1N|=0' }
    let(:decoded_string) { 'Encoded info' }

    before do
      allow(Base64).to \
        receive(:strict_decode64).with(encoded_string).
          and_return(decoded_string)
      expect(decoded_string).to receive(:force_encoding).with('utf-8')
    end

    describe '.decode' do
      it 'strictly decodes the string, forcing UTF-8 encoding' do
        decodable.decode_text(encoded_string)
      end
    end

    describe '.d' do
      it 'strictly decodes the string, forcing UTF-8 encoding' do
        decodable.d_text(encoded_string)
      end
    end

    describe '#decode' do
      it 'strictly decodes the string, forcing UTF-8 encoding' do
        decodable.new.decode_text(encoded_string)
      end
    end

    describe '#d' do
      it 'strictly decodes the string, forcing UTF-8 encoding' do
        decodable.new.d_text(encoded_string)
      end
    end
  end
end
