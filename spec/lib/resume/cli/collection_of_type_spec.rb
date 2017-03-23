require "resume/cli/collection_of_type"

module Resume
  module CLI
    module CollectionOfType
      RSpec.describe FontHash do
        describe ".===" do
          context "when other has a length > 1" do
            let(:long_hash) do
              { font: { foo: "foo" }, extra: { bar: "bar" } }
            end

            it "returns false" do
              expect(described_class === long_hash).to be false
            end
          end

          context "when other has length == 1 but key != :font" do
            let(:non_font_hash) do
              { something_else: { foo: "bar" } }
            end

            it "returns false" do
              expect(described_class === non_font_hash).to be false
            end
          end

          context "when other has length == 1, but :font != Hash of values" do
            let(:non_font_hash) { [:font, [1, 2, 3]] }

            it "returns false" do
              expect(described_class === non_font_hash).to be false
            end
          end

          context "when other has length == 1 and :font == Hash of values" do
            let(:font_hash) do
              { font: { foo: "bar" } }
            end

            it "returns true" do
              expect(described_class === font_hash).to be true
            end
          end
        end
      end

      RSpec.describe StylesArray do
        describe ".===" do
          context "when other has a length > 1" do
            let(:long_hash) do
              { styles: [1, 2, 3], extra: [4, 5, 6] }
            end

            it "returns false" do
              expect(described_class === long_hash).to be false
            end
          end

          context "when other has length == 1 but key != :styles" do
            let(:non_styles_array) { [:something_else, [1, 2, 3]] }

            it "returns false" do
              expect(described_class === non_styles_array).to be false
            end
          end

          context "when other has length == 1 but :styles != Array of values" do
            let(:non_styles_array) do
              { styles: { foo: "bar" } }
            end

            it "returns false" do
              expect(described_class === non_styles_array).to be false
            end
          end

          context "when other has length == 1 and :styles == Array of values" do
            let(:styles_array) do
              { styles: [1, 2, 3] }
            end

            it "returns true" do
              expect(described_class === styles_array).to be true
            end
          end
        end
      end
    end
  end
end
