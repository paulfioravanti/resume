require "spec_helper"
require "resume/cli/argument_parser"

module Resume
  module CLI
    RSpec.describe ArgumentParser do
      describe ".parse" do
        let(:parsing_options) { -> { described_class.parse } }

        context "when no options are specified" do
          before do
            stub_const("ARGV", [])
          end

          it "does nothing and changes nothing" do
            expect(described_class.parse).to eq([])
            expect(I18n.locale).to eq(:en)
          end
        end

        context "when an unsupported locale option is specified" do
          let(:unsupported_locale) { "eo" }

          before do
            stub_const("ARGV", ["-l", unsupported_locale])
          end

          it "raises a LocaleNotSupportedError for the locale" do
            expect(parsing_options).to \
              raise_error(LocaleNotSupportedError, unsupported_locale)
          end
        end

        context "when an invalid option is specified" do
          let(:invalid_option) { "-e" }

          before do
            stub_const("ARGV", [invalid_option])
          end

          it "raises an InvalidOptionError" do
            # can"t get direct access to the help message, so just
            # say that *something* is passed in with the exception
            expect(parsing_options).to \
              raise_error(InvalidOptionError, anything)
          end
        end

        context "when an argument is missing" do
          before do
            stub_const("ARGV", ["-l"])
          end

          it "raises a MissingArgumentError" do
            # can"t get direct access to the help message, so just
            # say that *something* is passed in with the exception
            expect(parsing_options).to \
              raise_error(MissingArgumentError, anything)
          end
        end

        context "when a supported locale option is specified" do
          let(:supported_locale) { "ja" }

          context "using the abbreviated option name" do
            before do
              stub_const("ARGV", ["-l", supported_locale])
              described_class.parse
            end

            it "sets the locale to the specified locale" do
              expect(I18n.locale).to eq(supported_locale.to_sym)
            end
          end

          context "using the full option name" do
            before do
              stub_const("ARGV", ["--locale", supported_locale])
              described_class.parse
            end

            it "sets the locale to the specified locale" do
              expect(I18n.locale).to eq(supported_locale.to_sym)
            end
          end
        end

        context "when the version option is specified" do
          let(:version) { "1.0" }

          before do
            stub_const("Resume::VERSION", version)
          end

          context "using the abbreviated option name" do
            before do
              stub_const("ARGV", ["-v"])
            end

            it "informs the user of the version number and halts" do
              expect(Output).to receive(:raw).with(version)
              expect(parsing_options).to throw_symbol(:halt)
            end
          end

          context "using the full option name" do
            before do
              stub_const("ARGV", ["--version"])
            end

            it "informs the user of the version number and halts" do
              expect(Output).to receive(:raw).with(version)
              expect(parsing_options).to throw_symbol(:halt)
            end
          end
        end

        context "when the help option is specified" do
          context "using the abbreviated option name" do
            before do
              stub_const("ARGV", ["-h"])
            end

            it "informs the user of the help options and halts" do
              # can"t get direct access to the help message, so just
              # say that *something* is output to stdout
              expect(Output).to receive(:raw).with(anything)
              expect(parsing_options).to throw_symbol(:halt)
            end
          end

          context "using the full option name" do
            before do
              stub_const("ARGV", ["--help"])
            end

            it "informs the user of the help options and halts" do
              # can"t get direct access to the help message, so just
              # say that *something* is output to stdout
              expect(Output).to receive(:raw).with(anything)
              expect(parsing_options).to throw_symbol(:halt)
            end
          end
        end
      end
    end
  end
end
