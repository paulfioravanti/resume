require 'spec_helper'
require 'resume'
require 'resume/cli/application'

RSpec.describe Resume do
  describe 'constants' do
    [:VERSION, :REMOTE_REPO, :REQUIRED_RUBY_VERSION].each do |const|
      context "for #{const}" do
        let(:defined_const) do
          described_class.const_defined?(const)
        end

        it 'is defined' do
          expect(defined_const).to be true
        end
      end
    end
  end

  describe '.generate' do
    it 'starts the CLI Application' do
      expect(described_class).to receive(:check_ruby_version)
      expect(described_class::CLI::Application).to receive(:start)
      described_class.generate
    end
  end

  describe '.check_ruby_version' do
    let(:checking_ruby_version) do
      -> { described_class.check_ruby_version }
    end

    context 'when a LoadError occurs when loading rubygems lib' do
      let(:message) do
        "Please install Ruby version 2.3.0 or higher "\
        "to generate resume.\n"\
        "Your Ruby version is ruby #{RUBY_VERSION}\n"
      end

      before do
        allow(described_class).to \
          receive(:require).with('rubygems').and_raise(LoadError)
        allow(described_class).to \
          receive(:require).with('open3').and_call_original
        expect(described_class).to receive(:exit)
      end

      it 'requests the user to install the expected Ruby version' do
        expect(checking_ruby_version).to output(message).to_stdout
      end
    end

    context 'when attempting to run the app with an old Ruby version' do
      let(:message) do
        "Please install Ruby version 2.3.0 or higher "\
        "to generate resume.\n"\
        "Your Ruby version is ruby #{RUBY_VERSION}\n"
      end

      before do
        stub_const('Resume::REQUIRED_RUBY_VERSION', '3.0.0')
        expect(described_class).to receive(:exit)
      end

      it 'requests the user to install the expected Ruby version' do
        expect(checking_ruby_version).to output(message).to_stdout
      end
    end


    context 'when a LoadError occurs when loading open3 lib' do
      let(:message) do
        "Please install Ruby version 2.3.0 or higher "\
        "to generate resume.\n"\
      end

      before do
        stub_const('Resume::REQUIRED_RUBY_VERSION', '3.0.0')
        allow(described_class).to \
          receive(:require).with('rubygems')
        allow(described_class).to \
          receive(:require).with('open3').and_raise(LoadError)
        expect(described_class).to receive(:exit)
      end

      it 'requests the user to install the expected Ruby version' do
        expect(checking_ruby_version).to output(message).to_stdout
      end
    end
  end
end
