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

  describe ".create" do
    # Needed to check that the expected filename gets generated
    include Decodable

    let(:filename) { "#{d(ResumeGenerator::DOCUMENT_NAME)}.pdf" }
    let(:cli) { double('cli').as_null_object }

    before do
      allow(Resume).to \
        receive(:background_image).and_return(placeholder_image)
      allow(Resource).to \
        receive(:open).with(anything).and_return(placeholder_image)
      Resume.create(cli)
    end
    after { File.delete(filename) }

    it 'generates a pdf resume and notifies the creation of each part' do
      expect(cli).to have_received(:inform_creation_of_social_media_links)
      expect(cli).to have_received(:inform_creation_of_employment_history)
      expect(cli).to have_received(:inform_creation_of_education_history)
      expect(File.exist?(filename)).to be true
    end
  end
end
