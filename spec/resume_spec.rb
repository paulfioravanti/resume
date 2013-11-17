require 'prawn'

describe Resume do
  # Link points to a 1x1 pixel placeholder to not slow down test suite
  # Couldn't send Prawn::Document an image test double
  let(:placeholder_image) do
    open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
  end

  describe ".generate" do
    let(:filename) { "#{ResumeGenerator::DOCUMENT_NAME}.pdf" }

    before do
      allow(Resume).to receive(:background_image).and_return(placeholder_image)
      allow(Resource).to \
        receive(:open).with(anything).and_return(placeholder_image)
      Resume.generate
    end
    after { File.delete(filename) }

    it 'generates a pdf resume' do
      expect(File.exist?(filename)).to be_true
    end
  end

  describe ".background_image" do
    before do
      allow(Resume).to \
        receive(:open).with(anything).and_return(placeholder_image)
    end

    it 'has a background image' do
      expect(Resume.background_image).to eq(placeholder_image)
    end
  end
end
