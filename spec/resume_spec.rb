require 'prawn'
require 'prawn/table'

RSpec.describe Resume do
  # Link points to a 1x1 pixel placeholder to not slow down test suite
  # Couldn't send Prawn::Document an image test double
  let(:placeholder_image) do
    open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
  end

  before do
    allow($stdout).to receive(:write) # suppress message cruft from stdout
  end

  # FIXME: I need a better spec
  # describe ".generate" do
  #   let(:filename) { "Resume.pdf" }
  #   let(:cli) { double('cli', language: 'en').as_null_object }
  #   let(:resume) { double('resume').as_null_object }
  #   let(:encoded_filename) { 'Encoded Document Name' }
  #   let(:decoded_filename) { 'Resume' }

  #   before do
  #     allow(JSON).to receive(:parse).and_return(resume)
  #     # allow(resume).to receive(:[]).with(:resume).and_return(resume)
  #     # allow(Resume).to receive(:resume).and_return(resume)
  #     allow(resume).to \
  #       receive(:[]).with(:document_name).and_return(encoded_filename)
  #     # allow(resume).to \
  #     #   receive(:[]).with(:background_image).and_return('abc')
  #     allow(Resume).to \
  #       receive(:d).with(encoded_filename).and_return(decoded_filename)
  #     # allow(Resume).to \
  #     #   receive(:open).with(anything).and_return(placeholder_image)
  #     # allow(Resource).to \
  #     #   receive(:open).with(anything).and_return(placeholder_image)
  #     Resume.generate(cli)
  #   end
  #   after { File.delete(filename) }

  #   it 'generates a pdf resume and notifies the creation of each part' do
  #     expect(cli).to have_received(:inform_creation_of_social_media_links)
  #     expect(cli).to have_received(:inform_creation_of_employment_history)
  #     expect(cli).to have_received(:inform_creation_of_education_history)
  #     expect(File.exist?(filename)).to be true
  #   end
  # end
end
