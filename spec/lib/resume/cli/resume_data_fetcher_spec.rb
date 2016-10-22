require "spec_helper"
require "resume/cli/resume_data_fetcher"

module Resume
  module CLI
    RSpec.describe ResumeDataFetcher do
      describe ".fetch" do
        let(:basename) { "resume.en.json" }
        let(:resume_data_path) { "resources/#{basename}" }
        let(:pathname) do
          instance_double(
            "Pathname",
            :pathname,
            basename: instance_double("Pathname", to_path: basename),
            to_path: resume_data_path,
            file?: true
          )
        end
        let(:resume_data_file) { spy("resume_data_file") }
        let(:json) { instance_double("Hash", :json_result) }

        before do
          allow(I18n).to receive(:locale).and_return(:en)
          allow(Pathname).to \
            receive(:new).with(resume_data_path).and_return(pathname)
          allow(File).to \
            receive(:open).with(pathname).
              and_return(resume_data_file)
          expect(Output).to \
            receive(:plain).with(:gathering_resume_information)
        end

        it "parses and returns the JSON resume data file" do
          expect(JSON).to \
            receive(:parse).
              with(resume_data_file, symbolize_names: true)
          described_class.fetch
        end
      end
    end
  end
end
