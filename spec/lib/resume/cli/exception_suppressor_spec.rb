require "resume/cli/exception_suppressor"

module Resume
  module CLI
    RSpec.describe ExceptionSuppressor do
      let(:suppressing_exception) do
        -> { suppress_exception }
      end

      describe "#suppress_exception_with_both_params" do
        let(:exception) { SystemExit }
        let(:suppress_exception) do
          described_class.suppress(exception, default) do
            raise exception_to_raise
          end
        end

        context "when specified exception to ignore is raised" do
          let(:exception_to_raise) { exception }
          let(:value) { "foo" }
          let(:default) { -> { value } }

          it "returns the default value" do
            expect(suppress_exception).to eq(value)
          end
        end

        context "when a non-ignored exception is raised" do
          let(:exception_to_raise) { LoadError }
          let(:default) { "bar" }

          it "re-raises the non-ignored exception" do
            expect(suppressing_exception).to \
              raise_error(exception_to_raise)
          end
        end
      end

      describe "#suppress_exception_with_one_param" do
        let(:exception) { SystemExit }
        let(:suppress_exception) do
          described_class.suppress(exception) do
            raise exception_to_raise
          end
        end

        context "when specified exception to ignore is raised" do
          let(:exception_to_raise) { exception }

          it "returns the the default empty lambda value" do
            expect(suppress_exception).to be nil
          end
        end

        context "when a non-ignored exception is raised" do
          let(:exception_to_raise) { LoadError }

          it "re-raises the non-ignored exception" do
            expect(suppressing_exception).to \
              raise_error(exception_to_raise)
          end
        end
      end

      describe "#suppress_exception_without_params" do
        let(:suppress_exception) do
          described_class.suppress do
            raise exception_to_raise
          end
        end

        context "StandardError is raised" do
          let(:exception_to_raise) { StandardError }

          it "returns the default empty lambda value" do
            expect(suppress_exception).to be nil
          end
        end

        context "when a non-ignored exception is raised" do
          let(:exception_to_raise) { LoadError }

          it "re-raises the non-ignored exception" do
            expect(suppressing_exception).to \
              raise_error(exception_to_raise)
          end
        end
      end
    end
  end
end
