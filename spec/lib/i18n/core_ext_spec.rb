require 'spec_helper'
require 'i18n/core_ext'

module I18n
  module Backend
    RSpec.describe Base do
      # Since #load_erb is a protected method, this spec tests the
      # interface that calls it: #load_translations
      describe '#load_translations' do
        let(:translations) do
          I18n.backend.instance_variable_get(:@translations)
        end

        before { I18n.backend = I18n::Backend::Simple.new }

        context 'when loading data from a yml.erb file' do
          let(:filename) { 'en.yml.erb' }
          let(:yaml) do
            <<-YAML
              en:
                foo: 1 + 1 = <%= 1 + 1 %>
            YAML
          end
          let(:erb_interpolated_hash) do
            { en: { foo: '1 + 1 = 2' } }
          end

          before do
            allow(File).to receive(:read).with(filename).and_return(yaml)
            I18n.backend.load_translations(filename)
          end

          it 'loads the data into a hash and interpolates the ERB' do
            expect(translations).to eq(erb_interpolated_hash)
          end
        end

        context 'when an error occurs' do
          let(:filename) { 'en.yml.erb' }
          let(:loading_translations) do
            -> { I18n.backend.load_translations(filename) }
          end
          let(:locale_error) do
            InvalidLocaleData.new(filename, error.inspect)
          end

          context 'when a TypeError occurs' do
            let(:error) { TypeError.new }

            before do
              allow(InvalidLocaleData).to \
                receive(:new).with(filename, error.inspect).
                  and_return(locale_error)
              allow(File).to receive(:read).and_raise(error)
            end

            it 'raises an InvalidLocaleData error' do
              expect(loading_translations).to raise_error(locale_error)
            end
          end

          context 'when a ScriptError occurs' do
            let(:error) { ScriptError.new }

            before do
              allow(InvalidLocaleData).to \
                receive(:new).with(filename, error.inspect).
                  and_return(locale_error)
              allow(File).to receive(:read).and_raise(error)
            end

            it 'raises an InvalidLocaleData error' do
              expect(loading_translations).to raise_error(locale_error)
            end
          end

          context 'when a StandardError occurs' do
            let(:error) { StandardError.new }

            before do
              allow(InvalidLocaleData).to \
                receive(:new).with(filename, error.inspect).
                  and_return(locale_error)
              allow(File).to receive(:read).and_raise(error)
            end

            it 'raises an InvalidLocaleData error' do
              expect(loading_translations).to raise_error(locale_error)
            end
          end
        end
      end
    end
  end
end
