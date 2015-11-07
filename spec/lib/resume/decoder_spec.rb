require 'resume/decoder'

module Resume
  RSpec.describe Decoder do
    describe '.decode' do
      let(:decode_object) { described_class.decode.call(object) }

      context 'when object is a Hash' do
        let(:object) { { key: value } }

        context 'when hash value is a Base64 string' do
          let(:decoded_object) { { key: decoded_value } }

          context 'when hash value is not a reserved word' do
            let(:value) { 'RW5jb2RlZA==' }
            let(:decoded_value) { 'Encoded' }

            it 'decodes the hash value' do
              expect(decode_object).to eq(decoded_object)
            end
          end

          context 'when hash value is a reserved word' do
            let(:value) { 'bold' }
            let(:decoded_value) { value }

            before do
              stub_const('Resume::RESERVED_WORDS', [value])
            end

            it 'returns the object unchanged' do
              expect(decode_object).to eq(decoded_object)
            end
          end
        end

        context 'when hash value is not a Base64 string' do
          let(:value) { 'A string' }

          it 'returns the object unchanged' do
            expect(decode_object).to eq(object)
          end
        end
      end

      context 'when object is an Array' do
        let(:object) { [value] }

        context 'when array value is a Base64 string' do
          let(:decoded_object) { [decoded_value] }

          context 'when array value is not a reserved word' do
            let(:value) { 'RW5jb2RlZA==' }
            let(:decoded_value) { 'Encoded' }

            it 'decodes the array value' do
              expect(decode_object).to eq(decoded_object)
            end
          end

          context 'when array value is a reserved word' do
            let(:value) { 'bold' }
            let(:decoded_value) { value }

            before do
              stub_const('Resume::RESERVED_WORDS', [value])
            end

            it 'returns the object unchanged' do
              expect(decode_object).to eq(decoded_object)
            end
          end
        end

        context 'when array value is not a Base64 string' do
          let(:value) { 'A string' }

          it 'returns the object unchanged' do
            expect(decode_object).to eq(object)
          end
        end
      end

      context 'when object is neither a Hash nor an Array' do
        let(:object) { 'A string' }

        it 'returns the object unchanged' do
          expect(decode_object).to eq(object)
        end
      end
    end
  end
end
