require "resume/cli/font_hash"

module Resume
  module CLI
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
  end
end
