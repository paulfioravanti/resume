require 'spec_helper'
require 'resume/settings'

module Resume
  RSpec.describe Settings do
    describe '.configure' do
      let(:configuration) { -> { described_class.configure } }

      context 'when development dependencies are not present' do
        before do
          allow(Settings).to receive(:require)
          allow(Settings).to \
            receive(:require).with('pry-byebug').and_raise(LoadError)
        end

        it 'ignores requiring gems that are just used in development' do
          expect(configuration).to_not raise_error
        end
      end

      context 'when i18n gem is not present' do
        before do
          allow(Settings).to receive(:require)
          allow(Settings).to \
            receive(:require).with('i18n').and_raise(LoadError)
        end

        it 'raises a DependencyPrerequisiteError' do
          expect(configuration).to raise_error(DependencyPrerequisiteError)
        end
      end
    end
  end
end
