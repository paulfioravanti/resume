require "resume/ruby_version_checker"

module Resume
  RSpec.describe RubyVersionChecker do
    describe ".check_ruby_version" do
      let(:checking_ruby_version) do
        -> { described_class.check_ruby_version }
      end

      before do
        stub_const("RUBY_VERSION", "2.4.0")
      end

      context "when a LoadError occurs when loading rubygems lib" do
        let(:message) do
          "Please install Ruby version 2.4.0 or higher "\
          "to generate resume.\n"\
          "Your Ruby version is ruby #{RUBY_VERSION}\n"
        end

        before do
          allow(described_class).to \
            receive(:require).with("rubygems").and_raise(LoadError)
          allow(described_class).to \
            receive(:require).with("open3").and_call_original
          allow(described_class).to receive(:exit).with(1)
        end

        it "requests the user to install a compatible Ruby version" do
          expect(checking_ruby_version).to output(message).to_stdout
          expect(described_class).to have_received(:exit).with(1)
        end
      end

      context "when attempting to run the app with an old Ruby version" do
        let(:message) do
          "Please install Ruby version 3.0.0 or higher "\
          "to generate resume.\n"\
          "Your Ruby version is ruby #{RUBY_VERSION}\n"
        end

        before do
          stub_const(
            # Pretend this version actually exists...
            "#{described_class}::REQUIRED_RUBY_VERSION",
            "3.0.0"
          )
          allow(described_class).to receive(:exit).with(1)
        end

        it "requests the user to install the expected Ruby version" do
          expect(checking_ruby_version).to output(message).to_stdout
          expect(described_class).to have_received(:exit).with(1)
        end
      end

      context "when a LoadError occurs when loading open3 lib" do
        let(:message) do
          "Please install Ruby version 3.0.0 or higher "\
          "to generate resume.\n"\
        end

        before do
          stub_const(
            # Pretend this version actually exists...
            "#{described_class}::REQUIRED_RUBY_VERSION",
            "3.0.0"
          )
          allow(described_class).to \
            receive(:require).with("rubygems")
          allow(described_class).to \
            receive(:require).with("open3").and_raise(LoadError)
          allow(described_class).to receive(:exit).with(1)
        end

        it "requests the user to install the expected Ruby version" do
          expect(checking_ruby_version).to output(message).to_stdout
          expect(described_class).to have_received(:exit).with(1)
        end
      end
    end
  end
end
