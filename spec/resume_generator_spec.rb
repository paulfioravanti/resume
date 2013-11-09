describe ResumeGenerator do
  describe 'constants' do
    let(:version) { ResumeGenerator.const_get('VERSION') }
    let(:document_name) { ResumeGenerator.const_get('DOCUMENT_NAME') }

    it 'has a VERSION constant' do
      expect(version).to_not be_empty
    end

    it 'has a DOCUMENT_NAME constant' do
      expect(document_name).to_not be_empty
    end
  end
end
