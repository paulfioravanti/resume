require "resume/cli/styles_array"

module Resume
  module CLI
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
