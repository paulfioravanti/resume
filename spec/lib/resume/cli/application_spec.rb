require 'resume/cli/application'

module Resume
  module CLI
    RSpec.describe Application do
      describe '.start' do
        context 'when an Error is raised' do
          let(:error_messages) { double('error_messages') }
          let(:error) { Error.new }
          let(:starting_the_app) do
            -> { described_class.start }
          end

          before do
            allow(Settings).to \
              receive(:configure).and_raise(error)
          end

          it 'outputs the error messages' do
            expect(Output).to \
              receive(:messages).with(error.messages)
            described_class.start
          end
        end

        context 'when a halt is thrown' do
          before do
            allow(Settings).to receive(:configure)
            allow(ArgumentParser).to receive(:parse).and_throw(:halt)
          end

          it 'halts operation at the point halt is thrown' do
            expect(ResumeDataFetcher).to_not receive(:fetch)
            described_class.start
          end
        end
      end
    end
  end
end
