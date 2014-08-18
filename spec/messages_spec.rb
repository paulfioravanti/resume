RSpec.describe Messages do
  let(:klass) { Class.new { include Messages }.new }
  let(:outputting_message) { -> { message } }

  describe '#inform_creation_of_social_media_links' do
    let(:message) { klass.inform_creation_of_social_media_links }

    it 'outputs a message to stdout' do
      expect(outputting_message).to output.to_stdout
    end
  end

  describe '#inform_creation_of_employment_history' do
    let(:message) { klass.inform_creation_of_employment_history }

    it 'outputs a message to stdout' do
      expect(outputting_message).to output.to_stdout
    end
  end

  describe '#inform_creation_of_education_history' do
    let(:message) { klass.inform_creation_of_education_history }

    it 'outputs a message to stdout' do
      expect(outputting_message).to output.to_stdout
    end
  end
end
