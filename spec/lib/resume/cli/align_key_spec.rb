require "resume/cli/align_key"

module Resume
  module CLI
    RSpec.describe AlignKey do
      describe ".===" do
        context "when other has a length > 1" do
          let(:long_hash) { { align: 1, extra: 2 } }

          it "returns false" do
            expect(described_class === long_hash).to be false
          end
        end

        context "when other has length == 1 but key != :align" do
          let(:non_align_key) { { something_else: 1 } }

          it "returns false" do
            expect(described_class === non_align_key).to be false
          end
        end

        context "when other has length == 1 and key == :align" do
          let(:align_key) { { align: 1 } }

          it "returns true" do
            expect(described_class === align_key).to be true
          end
        end
      end
    end
  end
end
