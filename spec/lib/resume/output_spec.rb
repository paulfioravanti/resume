require 'spec_helper'
require 'resume/output'

module Resume
  RSpec.describe Output do
    shared_context 'Colourised I18n keys' do |colour|
      let(:key) { :message }
      let(:params_to_interpolate) { { param: 'param' } }
      let(:params) { [key, params_to_interpolate] }
      let(:translated_message) { 'Translated Message' }
      let(:colourised_translated_message) do
        "Colourised #{translated_message}"
      end
      let(:colourised_translated_message_with_new_line) do
        "#{colourised_translated_message}\n"
      end

      before do
        allow(I18n).to receive(:translate).
          with(key, params_to_interpolate).
            and_return(translated_message)
        allow(described_class).to \
          receive(colour).with(translated_message).
            and_return(colourised_translated_message)
      end
    end

    shared_context 'Raw colourised strings' do |colour|
      let(:message) { 'The message' }
      let(:colourised_message) do
        "Colourised #{message}"
      end
      let(:message_with_new_line) do
        "#{colourised_message}\n"
      end

      before do
        allow(described_class).to \
          receive(colour).with(message).
            and_return(colourised_message)
      end
    end

    describe '.messages' do
      let(:messages) { { error: :foo, warning: :bar } }

      it 'calls to output each message as its specific type' do
        messages.each do |type, key|
          expect(described_class).to receive(type).with(key)
        end
        described_class.messages(messages)
      end
    end

    describe '.error' do
      include_context 'Colourised I18n keys', :red

      let(:outputting_the_error) { -> { described_class.error(params) } }

      it 'outputs the values of the I18n-ised error to stdout' do
        expect(outputting_the_error).to \
          output(colourised_translated_message_with_new_line).to_stdout
      end
    end

    describe '.warning' do
      include_context 'Colourised I18n keys', :yellow

      let(:outputting_the_warning) do
        -> { described_class.warning(params) }
      end

      it 'outputs the values of the I18n-ised warning to stdout' do
        expect(outputting_the_warning).to \
          output(colourised_translated_message_with_new_line).to_stdout
      end
    end

    describe '.question' do
      include_context 'Colourised I18n keys', :yellow

      let(:outputting_the_question) do
        -> { described_class.question(params) }
      end

      it 'outputs the values of the I18n-ised question to stdout' do
        expect(outputting_the_question).to \
          output(colourised_translated_message).to_stdout
      end
    end

    describe '.success' do
      include_context 'Colourised I18n keys', :green

      let(:outputting_the_success_message) do
        -> { described_class.success(params) }
      end

      it 'outputs the values of the I18n-ised success message to stdout' do
        expect(outputting_the_success_message).to \
          output(colourised_translated_message_with_new_line).to_stdout
      end
    end

    describe '.info' do
      include_context 'Colourised I18n keys', :cyan

      let(:outputting_the_info_message) do
        -> { described_class.info(params) }
      end

      it 'outputs the values of the I18n-ised info message to stdout' do
        expect(outputting_the_info_message).to \
          output(colourised_translated_message_with_new_line).to_stdout
      end
    end

    describe '.plain' do
      let(:key) { :message }
      let(:params_to_interpolate) { { param: 'param' } }
      let(:params) { [key, params_to_interpolate] }
      let(:translated_message) { 'Translated Message' }
      let(:translated_message_with_new_line) { "#{translated_message}\n" }
      let(:outputting_the_plain_message) do
        -> { described_class.plain(params) }
      end

      before do
        allow(I18n).to receive(:translate).
          with(key, params_to_interpolate).and_return(translated_message)
      end

      it 'outputs the values of the I18n-ised plain message to stdout' do
        expect(outputting_the_plain_message).to \
          output(translated_message_with_new_line).to_stdout
      end
    end

    describe '.raw_error' do
      include_context 'Raw colourised strings', :red

      let(:outputting_the_raw_error) do
        -> { described_class.raw_error(message) }
      end

      it 'outputs the colourised error message to stdout' do
        expect(outputting_the_raw_error).to \
          output(message_with_new_line).to_stdout
      end
    end

    describe '.raw_warning' do
      include_context 'Raw colourised strings', :yellow

      let(:outputting_the_raw_warning) do
        -> { described_class.raw_warning(message) }
      end

      it 'outputs the colourised warning message to stdout' do
        expect(outputting_the_raw_warning).to \
          output(message_with_new_line).to_stdout
      end
    end

    describe '.raw_success' do
      include_context 'Raw colourised strings', :green

      let(:outputting_the_raw_success_message) do
        -> { described_class.raw_success(message) }
      end

      it 'outputs the colourised warning message to stdout' do
        expect(outputting_the_raw_success_message).to \
          output(message_with_new_line).to_stdout
      end
    end

    describe '.raw' do
      let(:message) { 'The message' }
      let(:message_with_new_line) { "#{message}\n" }
      let(:outputting_the_raw_message) do
        -> { described_class.raw(message) }
      end

      it 'outputs the values of the message to stdout' do
        expect(outputting_the_raw_message).to \
          output(message_with_new_line).to_stdout
      end
    end
  end
end
