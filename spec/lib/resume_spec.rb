require "spec_helper"
require "resume"
require "resume/ruby_version_checker"
require "resume/cli/application"

RSpec.describe Resume do
  describe "constants" do
    [:VERSION, :REMOTE_REPO].each do |const|
      context "for #{const}" do
        let(:defined_const) do
          described_class.const_defined?(const)
        end

        it "is defined" do
          expect(defined_const).to be true
        end
      end
    end
  end

  describe ".generate" do
    it "starts the CLI Application" do
      expect(described_class::RubyVersionChecker).to \
        receive(:check_ruby_version)
      expect(described_class::CLI::Application).to receive(:start)
      described_class.generate
    end
  end
end
