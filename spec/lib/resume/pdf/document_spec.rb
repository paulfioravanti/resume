require 'resume/pdf/document'
require 'resume/cli/application'

RSpec.describe Resume::PDF::Document do
  let(:locale) { :en }
  let(:app) { Resume::CLI::Application.new(locale) }
  let(:resume_data_path) { "#{Resume::DATA_LOCATION}resume.#{app.locale}.json" }

  before do
    allow($stdout).to receive(:write) # suppress message cruft from stdout
  end

  describe '.generate' do
    context 'when a network connection cannot be made' do
      let(:generating_the_resume) { -> { described_class.generate(app) } }

      before do
        allow(JSON).to receive(:parse).and_raise(SocketError)
      end

      it 'informs the user of the network connection issue and exits' do
        expect(app).to \
          receive(:inform_of_network_connection_issue).and_call_original
        expect(generating_the_resume).to raise_error(SystemExit)
      end
    end

    context 'when a network connection can be made' do
      let(:document) { double('document') }
      let(:resume) { double('resume') }
      let(:resume_json) { double('resume_json') }
      let(:encoded_filename) { '3nC0D3d F1l3N4M3' }
      let(:decoded_filename) { 'Decoded Filename' }
      let(:app_filename) { "#{decoded_filename}_#{app.locale}.pdf" }

      before do
        allow(described_class).to \
          receive(:open).with(resume_data_path).and_return(resume_json)
        allow(resume_json).to receive(:read).and_return(resume_json)
        allow(JSON).to \
          receive(:parse).with(resume_json, { symbolize_names: true }).
            and_return(resume)
        allow(resume).to \
          receive(:[]).with(:resume).and_return(resume)
        allow(resume).to \
          receive(:[]).with(:document_name).and_return(encoded_filename)
        allow(described_class).to \
          receive(:d).with(encoded_filename).and_return(decoded_filename)
      end

      it 'creates a new Document and calls #generate' do
        expect(app).to receive(:filename=).with(app_filename)
        expect(described_class).to \
          receive(:new).with(resume, app).and_return(document)
        expect(document).to receive(:generate)
        described_class.generate(app)
      end
    end
  end

  describe '#generate' do
    # Link points to a 1x1 pixel placeholder to not slow down test suite
    # Couldn't send Prawn::Document an image test double
    let(:placeholder_image) do
      open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
    end
    let(:resume) do
      JSON.parse(open(resume_data_path).read, symbolize_names: true)[:resume]
    end
    let(:filename) { 'My Resume.pdf' }
    let(:document) { described_class.new(resume, app) }

    before do
      allow(app).to receive(:filename).and_return(filename)
      allow(Resume::PDF::Logo).to \
        receive(:open).with(anything).and_return(placeholder_image)
      allow(Resume::PDF::Options).to \
        receive(:open).with(anything).and_return(placeholder_image)
    end
    after { File.delete(filename) }

    it 'generates a pdf resume and notifies the creation of each part' do
      expect(app).to \
        receive(:inform_creation_of_social_media_links).and_call_original
      expect(app).to \
        receive(:inform_creation_of_technical_skills).and_call_original
      expect(app).to \
        receive(:inform_creation_of_employment_history).and_call_original
      expect(app).to \
        receive(:inform_creation_of_education_history).and_call_original
      document.generate
      expect(File.exist?(filename)).to be true
    end
  end
end
