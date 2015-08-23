require 'resume/exceptions'

module Resume
  RSpec.describe DependencyPrerequisiteError do
    let(:error) { described_class.new }

    describe '#messages' do
      let(:messages) do
        {
          raw_error:
            'My resume and the specs are bilingual and need the I18n gem.',
          raw_warning: 'Please run: gem install i18n'
        }
      end

      it 'contains strings to output the error and warning messages' do
        expect(error.messages).to eq(messages)
      end
    end
  end

  RSpec.describe NetworkConnectionError do
    let(:error) { described_class.new }

    describe '#messages' do
      let(:messages) do
        {
          error: :cant_connect_to_the_internet,
          warning: :please_check_your_network_settings
        }
      end

      it 'contains keys to output the error and warning messages' do
        expect(error.messages).to eq(messages)
      end
    end
  end
end
