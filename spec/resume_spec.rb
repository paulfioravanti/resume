require 'prawn'

describe Resume do
  describe ".generate" do
    # Link points to a 1x1 pixel placeholder to not slow down test suite
    # Couldn't send Prawn::Document an image test double
    let(:placeholder_image) do
      open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
    end
    let(:filename) { "#{ResumeGenerator::DOCUMENT_NAME}.pdf" }

    before do
      allow(Image).to receive(:for).with(anything).and_return(placeholder_image)
      Resume.generate
    end
    after { File.delete(filename) }

    it 'generates a pdf resume' do
      expect(File.exist?(filename)).to be_true
    end
  end
end
