require 'resume/dependency_prerequisite_error'

module Resume
  RSpec.describe DependencyPrerequisiteError do
    let(:error) { described_class.new }

    describe '#messages' do
      let(:messages) do
        {
          raw_error: 'My resume is bilingual and needs the I18n gem.',
          raw_warning: 'Please run: gem install i18n'
        }
      end

      it 'contains strings to output the error and warning messages' do
        expect(error.messages).to eq(messages)
      end
    end
  end
end
