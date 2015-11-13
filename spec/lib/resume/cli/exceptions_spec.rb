require 'resume/cli/exceptions'

module Resume
  module CLI
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

    RSpec.describe DependencyInstallationPermissionError do
      let(:error) { described_class.new }

      describe '#messages' do
        let(:messages) do
          {
            error: :cannot_generate_pdf_without_dependencies,
            warning: :please_ask_me_directly_for_a_pdf_copy
          }
        end

        it 'contains keys to output the error and warning messages' do
          expect(error.messages).to eq(messages)
        end
      end
    end

    RSpec.describe DependencyInstallationError do
      let(:error) { described_class.new }

      describe '#messages' do
        let(:messages) do
          {
            error: :dependency_installation_failed,
            warning: :try_again_or_ask_me_directly_for_a_pdf_copy
          }
        end

        it 'contains keys to output the error and warning messages' do
          expect(error.messages).to eq(messages)
        end
      end
    end

    RSpec.describe LocaleNotSupportedError do
      let(:locale) { 'fr' }
      let(:error) { described_class.new(locale) }

      describe '#messages' do
        let(:messages) do
          {
            error: [
              :locale_is_not_supported,
              { specified_locale: locale }
            ],
            warning: :supported_locales_are
          }
        end

        it 'contains keys to output the error and warning messages' do
          expect(error.messages).to eq(messages)
        end
      end
    end

    RSpec.describe InvalidOptionError do
      let(:options) { 'Options' }
      let(:error) { described_class.new(options) }

      describe '#messages' do
        let(:messages) do
          {
            error: :you_have_some_invalid_options,
            raw: options
          }
        end

        it 'contains keys and raw string to output the messages' do
          expect(error.messages).to eq(messages)
        end
      end
    end

    RSpec.describe MissingArgumentError do
      let(:options) { 'Options' }
      let(:error) { described_class.new(options) }

      describe '#messages' do
        let(:messages) do
          {
            error: :you_have_a_missing_argument,
            raw: options
          }
        end

        it 'contains keys and raw string to output the messages' do
          expect(error.messages).to eq(messages)
        end
      end
    end
  end
end
