require "resume/cli/styles_array"

module Resume
  module CLI
    RSpec.describe StylesArray do
      describe ".===" do
        context "when other has a styles key with an Array of values" do
          let(:styles_array) { [:styles, [1, 2, 3]] }

          it "returns true" do
            expect(described_class === styles_array).to be true
          end
        end

        context "when other has a non-styles key with an Array of values" do
          let(:non_styles_array) { [:something_else, [1, 2, 3]] }

          it "returns false" do
            expect(described_class === non_styles_array).to be false
          end
        end

        context "when other has a styles key but not an Array of values" do
          let(:non_styles_array) { [:styles, { foo: "bar" }] }

          it "returns false" do
            expect(described_class === non_styles_array).to be false
          end
        end
      end
    end
  end
end
