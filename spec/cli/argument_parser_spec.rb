require 'spec_helper'
require 'resume_generator/cli/argument_parser'

RSpec.describe ResumeGenerator::CLI::ArgumentParser do
  let(:argument_parser) { described_class.new }

  describe '#parse!' do
    before do
      allow($stdout).to receive(:write) # suppress message cruft from stdout
    end

    context 'when no locale option is specified' do
      let(:default_locale) { :en }

      before do
        stub_const('ARGV', [])
        argument_parser.parse!
      end

      it 'sets the default locale' do
        expect(argument_parser.locale).to eq(default_locale)
      end
    end

    context 'when an unsupported locale option is specified' do
      let(:supported_locales) { [:en, :ja] }
      let(:unsupported_locale) { 'eo' }
      let(:parsing_options) { -> { argument_parser.parse! } }

      before do
        allow(argument_parser).to \
          receive(:supported_locales).and_return(supported_locales)
        stub_const('ARGV', ['-l', unsupported_locale])
      end

      it 'informs the user of the supported locales and exits' do
        expect(argument_parser).to \
          receive(:inform_locale_not_supported).with(unsupported_locale).
            and_call_original
        expect(parsing_options).to raise_error(SystemExit)
      end
    end

    context 'when a supported locale option is specified' do
      let(:supported_locales) { [:en, :ja] }
      let(:supported_locale) { 'ja' }

      before do
        allow(argument_parser).to \
          receive(:supported_locales).and_return(supported_locales)
      end

      context 'using the abbreviated option name' do
        before do
          stub_const('ARGV', ['-l', supported_locale])
          argument_parser.parse!
        end

        it 'sets the locale to the specified locale' do
          expect(argument_parser.locale).to eq(supported_locale.to_sym)
        end
      end

      context 'using the full option name' do
        before do
          stub_const('ARGV', ['--locale', supported_locale])
          argument_parser.parse!
        end

        it 'sets the locale to the specified locale' do
          expect(argument_parser.locale).to eq(supported_locale.to_sym)
        end
      end
    end

    context 'when the version option is specified' do
      let(:version) { '1.0' }
      let(:parsing_options) { -> { argument_parser.parse! } }

      before do
        stub_const('ResumeGenerator::VERSION', version)
      end

      context 'using the abbreviated option name' do
        before do
          stub_const('ARGV', ['-v'])
        end

        it 'informs the user of the version number and exits' do
          expect(parsing_options).to \
            output(argument_parser.parser.version).to_stdout.and \
              raise_error(SystemExit)
        end
      end

      context 'using the full option name' do
        before do
          stub_const('ARGV', ['--version'])
        end

        it 'informs the user of the version number and exits' do
          expect(parsing_options).to \
            output(argument_parser.parser.version).to_stdout.and \
              raise_error(SystemExit)
        end
      end
    end

    context 'when the help option is specified' do
      let(:parsing_options) { -> { argument_parser.parse! } }

      context 'using the abbreviated option name' do
        before do
          stub_const('ARGV', ['-h'])
        end

        it 'informs the user of the application options and exits' do
          expect(parsing_options).to \
            output(argument_parser.parser.help).to_stdout.and \
              raise_error(SystemExit)
        end
      end

      context 'using the full option name' do
        before do
          stub_const('ARGV', ['--help'])
        end

        it 'informs the user of the application options and exits' do
          expect(parsing_options).to \
            output(argument_parser.parser.help).to_stdout.and \
              raise_error(SystemExit)
        end
      end
    end

    context 'when an invalid option is specified' do
      let(:parsing_options) { -> { argument_parser.parse! } }

      before do
        stub_const('ARGV', ['-invalid'])
      end

      it 'informs the user that there is an invalid option and exits' do
        expect(argument_parser).to \
          receive(:inform_of_invalid_options).and_call_original
        expect(parsing_options).to raise_error(SystemExit)
      end
    end

    context 'when a specified valid option has a missing argument' do
      let(:parsing_options) { -> { argument_parser.parse! } }

      before do
        stub_const('ARGV', ['-l'])
      end

      it 'informs the user that there is a missing argument and exits' do
        expect(argument_parser).to \
          receive(:inform_of_missing_arguments).and_call_original
        expect(parsing_options).to raise_error(SystemExit)
      end
    end
  end
end
