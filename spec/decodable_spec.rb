require 'spec_helper'

describe Decodable do
  let(:decoder) { Object.new.extend(Decodable) }

  describe '.d' do
    it 'wraps the Base64.strict_decode64 method' do
      expect(Base64).to receive(:strict_decode64).with('Hello')
      decoder.d('Hello')
    end
  end
end