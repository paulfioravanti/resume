require 'spec_helper'
require 'resume/cli/resume_data_fetcher'

module Resume
  module CLI
    RSpec.describe ResumeDataFetcher do
      describe '.fetch' do
        let(:resume_data_filename) { 'resume.json' }
        # null object to return self when #read called on it
        let(:resume_data_file) do
          spy('resume_data_file')
        end

        before do
          allow(I18n).to \
            receive(:t).with(
              :resume_data_filename,
              selected_locale: I18n.locale
            ).and_return(resume_data_filename)
          allow(FileFetcher).to \
            receive(:fetch).with(resume_data_filename).
              and_return(resume_data_file)
          expect(Output).to \
            receive(:plain).with(:gathering_resume_information)
        end

        it 'parses and returns the JSON resume data file' do
          expect(JSON).to receive(:parse).with(
            resume_data_file, symbolize_names: true
          )
          described_class.fetch
        end
      end
    end
  end
end
