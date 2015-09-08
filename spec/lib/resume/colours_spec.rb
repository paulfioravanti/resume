require 'resume/colours'

module Resume
  RSpec.describe Colours do
    let(:colourable) do
      Class.new do
        include Colours

        def red_text(text); red(text); end

        def green_text(text); green(text); end

        def yellow_text(text); yellow(text); end

        def cyan_text(text); cyan(text); end

      end.new
    end
    let(:text) { 'Hello' }

    describe '#red_text' do
      let(:red_text) { colourable.red_text(text) }
      let(:ansi_escaped_red_text) { "\e[31m#{text}\e[0m" }

      it 'returns the text formatted to output in red on terminals' do
        expect(red_text).to eq(ansi_escaped_red_text)
      end
    end

    describe '#green_text' do
      let(:green_text) { colourable.green_text(text) }
      let(:ansi_escaped_green_text) { "\e[32m#{text}\e[0m" }

      it 'returns the text formatted to output in green on terminals' do
        expect(green_text).to eq(ansi_escaped_green_text)
      end
    end

    describe '#yellow_text' do
      let(:yellow_text) { colourable.yellow_text(text) }
      let(:ansi_escaped_yellow_text) { "\e[33m#{text}\e[0m" }

      it 'returns the text formatted to output in yellow on terminals' do
        expect(yellow_text).to eq(ansi_escaped_yellow_text)
      end
    end

    describe '#cyan_text' do
      let(:cyan_text) { colourable.cyan_text(text) }
      let(:ansi_escaped_cyan_text) { "\e[36m#{text}\e[0m" }

      it 'returns the text formatted to output in cyan on terminals' do
        expect(cyan_text).to eq(ansi_escaped_cyan_text)
      end
    end
  end
end
