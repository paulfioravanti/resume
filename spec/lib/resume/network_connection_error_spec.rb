require 'resume/network_connection_error'

module Resume
  RSpec.describe NetworkConnectionError do
    let(:error) { NetworkConnectionError.new }

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
