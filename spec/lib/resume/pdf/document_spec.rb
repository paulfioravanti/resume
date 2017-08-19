require "spec_helper"
require "resume/cli/resume_data_fetcher"
require "resume/cli/content_parser"
require "resume/pdf/document"

module Resume
  module PDF
    RSpec.describe Document do
      before do
        # Use the en locale to test document generation since it
        # requires the least amount of outside dependencies
        allow(I18n).to receive(:locale).and_return(:en)
        allow(Console).to \
          receive(:plain).with(:gathering_resume_information)
      end

      describe ".generate" do
        let!(:resume) do
          CLI::ContentParser.parse(CLI::ResumeDataFetcher.fetch)
        end
        let(:title) { "My Resume" }
        let(:filename) { "My_Resume.pdf" }

        before do
          allow(Console).to \
            receive(:plain).with(:creating_social_media_links)
          allow(Console).to \
            receive(:plain).with(:creating_technical_skills_section)
          allow(Console).to \
            receive(:plain).with(:creating_employment_history_section)
          allow(Console).to \
            receive(:plain).with(:creating_education_history_section)
          described_class.generate(resume, title, filename)
        end
        after { File.delete(filename) }

        it "generates a pdf resume with progress notifications" do
          expect(Console).to \
            have_received(:plain).with(:creating_social_media_links)
          expect(Console).to \
            have_received(:plain).with(:creating_technical_skills_section)
          expect(Console).to \
            have_received(:plain).with(:creating_employment_history_section)
          expect(Console).to \
            have_received(:plain).with(:creating_education_history_section)
          expect(File.exist?(filename)).to be true
        end
      end
    end
  end
end
