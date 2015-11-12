require 'resume/content_parser'

module Resume
  RSpec.describe ContentParser do
    describe '.parse' do
      let(:decode_object) { described_class.parse.call(object) }

      context 'when object is a Hash' do
        let(:object) { { key: value } }

        context 'when hash value is a Base64 string' do
          context 'when hash value is not a reserved word' do
            let(:value) { 'RW5jb2RlZA==' }
            let(:decoded_object) { { key: 'Encoded' } }

            it 'decodes the hash value' do
              expect(decode_object).to eq(decoded_object)
            end
          end

          context 'when hash value is a reserved word' do
            let(:value) { 'bold' }

            before do
              stub_const('Resume::RESERVED_WORDS', [value])
            end

            it 'returns the object unchanged' do
              expect(decode_object).to eq(object)
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

          context 'when array value is not a reserved word' do
            let(:value) { 'RW5jb2RlZA==' }
            let(:decoded_object) { ['Encoded'] }

            it 'decodes the array value' do
              expect(decode_object).to eq(decoded_object)
            end
          end

          context 'when array value is a reserved word' do
            let(:value) { 'bold' }

            before do
              stub_const('Resume::RESERVED_WORDS', [value])
            end

            it 'returns the object unchanged' do
              expect(decode_object).to eq(object)
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
