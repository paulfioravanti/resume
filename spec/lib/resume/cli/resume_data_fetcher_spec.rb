require "spec_helper"
require "resume/cli/resume_data_fetcher"

module Resume
  module CLI
    RSpec.describe ResumeDataFetcher do
      describe ".fetch" do
        let(:basename) { "resume.en.json" }
        let(:resume_data_path) { "resources/#{basename}" }
        let(:resume_data_file) { instance_spy(File, :resume_data_file) }

        before do
          allow(Output).to \
            receive(:plain).with(:gathering_resume_information)
          allow(I18n).to receive(:locale).and_return(:en)
          allow(FileFetcher).to \
            receive(:fetch).with(resume_data_path).
              and_return(resume_data_file)
          allow(JSON).to \
            receive(:parse).
              with(resume_data_file, symbolize_names: true)
          described_class.fetch
        end

        it "parses and returns the JSON resume data file" do
          expect(Output).to \
            have_received(:plain).with(:gathering_resume_information)
          expect(JSON).to \
            have_received(:parse).
              with(resume_data_file, symbolize_names: true)
        end
      end
    end
  end
end
