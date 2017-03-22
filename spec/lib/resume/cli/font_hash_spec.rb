require "resume/cli/font_hash"

module Resume
  module CLI
    RSpec.describe FontHash do
      describe ".===" do
        context "when other has a font key with a Hash of values" do
          let(:font_hash) { [:font, { foo: "bar" }] }

          it "returns true" do
            expect(described_class === font_hash).to be true
          end
        end

        context "when other has a non-font key with a Hash of values" do
          let(:non_font_hash) { [:something_else, { foo: "bar" }] }

          it "returns false" do
            expect(described_class === non_font_hash).to be false
          end
        end

        context "when other has a font key but not a Hash of values" do
          let(:non_font_hash) { [:font, [1, 2, 3]] }

          it "returns false" do
            expect(described_class === non_font_hash).to be false
          end
        end
      end
    end
  end
end
