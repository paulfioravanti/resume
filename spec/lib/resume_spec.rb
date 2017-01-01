require "spec_helper"
require "resume"
require "resume/ruby_version_checker"
require "resume/cli/application"

RSpec.describe Resume do
  specify "resume has a VERSION" do
    expect(described_class.const_defined?(:VERSION)).to be true
  end

  describe ".generate" do
    before do
      allow(described_class::RubyVersionChecker).to receive(:check_ruby_version)
      allow(described_class::CLI::Application).to receive(:start)
      described_class.generate
    end

    it "starts the CLI Application" do
      expect(described_class::RubyVersionChecker).to \
        have_received(:check_ruby_version)
      expect(described_class::CLI::Application).to have_received(:start)
    end
  end
end
