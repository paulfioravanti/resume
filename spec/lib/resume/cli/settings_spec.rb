require "spec_helper"
require "resume/cli/settings"

module Resume
  module CLI
    RSpec.describe Settings do
      describe ".configure" do
        let(:configure) { described_class.configure }

        context "when development dependencies are not present" do
          before do
            allow(described_class).to receive(:require)
            allow(described_class).to \
              receive(:require).with("pry-byebug").and_raise(LoadError)
          end

          it "ignores requiring gems used only in development" do
            expect { configure }.not_to raise_error
          end
        end

        context "when i18n gem is not present" do
          before do
            allow(described_class).to receive(:require)
            allow(described_class).to \
              receive(:require).with("i18n").and_raise(LoadError)
          end

          it "raises a DependencyPrerequisiteError" do
            expect { configure }.to \
              raise_error(DependencyPrerequisiteError)
          end
        end
      end
    end
  end
end
