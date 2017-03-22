require "resume/cli/align_key"

module Resume
  module CLI
    RSpec.describe AlignKey do
      describe ".===" do
        context "when other has an align key" do
          let(:align_key) { [:align, 1] }

          it "returns true" do
            expect(described_class === align_key).to be true
          end
        end

        context "when other does not have an align key" do
          let(:non_align_key) { [:something_else, 1] }

          it "returns false" do
            expect(described_class === non_align_key).to be false
          end
        end
      end
    end
  end
end
