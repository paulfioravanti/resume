require 'i18n'

RSpec.describe I18n::Backend::Base do
  # Since #load_erb is a protected method, this spec tests the
  # interface that calls it: #load_translations
  describe '#load_translations' do
    let(:translations) do
      I18n.backend.instance_variable_get(:@translations)
    end

    before do
      I18n.backend = I18n::Backend::Simple.new
    end

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
  end
end
