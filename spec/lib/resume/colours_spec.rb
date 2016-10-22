require 'resume/colours'

module Resume
  RSpec.describe Colours do
    let(:text) { 'Hello' }

    describe '.red' do
      let(:red_text) { described_class.red(text) }
      let(:ansi_escaped_red_text) { "\e[31m#{text}\e[0m" }

      it 'returns the text formatted to output in red on terminals' do
        expect(red_text).to eq(ansi_escaped_red_text)
      end
    end

    describe '.green' do
      let(:green_text) { described_class.green(text) }
      let(:ansi_escaped_green_text) { "\e[32m#{text}\e[0m" }

      it 'returns the text formatted to output in green on terminals' do
        expect(green_text).to eq(ansi_escaped_green_text)
      end
    end

    describe '.yellow' do
      let(:yellow_text) { described_class.yellow(text) }
      let(:ansi_escaped_yellow_text) { "\e[33m#{text}\e[0m" }

      it 'returns the text formatted to output in yellow on terminals' do
        expect(yellow_text).to eq(ansi_escaped_yellow_text)
      end
    end

    describe '.cyan' do
      let(:cyan_text) { described_class.cyan(text) }
      let(:ansi_escaped_cyan_text) { "\e[36m#{text}\e[0m" }

      it 'returns the text formatted to output in cyan on terminals' do
        expect(cyan_text).to eq(ansi_escaped_cyan_text)
      end
    end
  end
end
