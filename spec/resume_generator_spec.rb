RSpec.describe ResumeGenerator do
  describe 'constants' do
    let(:version) { ResumeGenerator.const_get('VERSION') }

    it 'has a VERSION constant' do
      expect(version).to_not be_empty
    end
  end
end
