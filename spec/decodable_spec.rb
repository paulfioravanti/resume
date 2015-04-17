RSpec.describe Decodable do
  let(:decoder) { Object.new.extend(Decodable) }

  describe '.d' do
    # This represents any Base64 encoded string
    let(:encoded_string) { 'xxx' }
    # This could be a string like 'Hello' or if the original string had UTF-8
    # characters, it could be something like
    # '\xE3\x81\x93\xE3\x82\x93\xE3\x81\xAB\xE3\x81\xA1\xE3\x81\xAF'
    let(:ascii_string) { 'yyy' }
    let(:utf8_string) { 'zzz' }
    let(:decoded_string) { decoder.d(encoded_string) }

    before do
      allow(Base64).to \
        receive(:strict_decode64).with(encoded_string).and_return(ascii_string)
      allow(ascii_string).to \
        receive(:force_encoding).with('utf-8').and_return(utf8_string)
    end

    it 'converts the ASCII string into UTF-8' do
      expect(decoded_string).to eq(utf8_string)
    end
  end
end
