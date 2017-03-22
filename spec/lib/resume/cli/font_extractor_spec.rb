require "resume/cli/font_extractor"

module Resume
  module CLI
    RSpec.describe FontExtractor do
      describe ".extract" do
        # NOTE: For the most part, mocking this out is complete madness,
        # but I did not want the test suite to be dependent on the
        # rubyzip gem since it is not used to generate all resumes
        let(:filename) { "resume_IPAfont00303.zip" }
        let(:normal_font_name) { "ipamp.ttf" }
        let(:bold_font_name) { "ipagp.ttf" }
        let(:font) do
          {
            filename: filename,
            files: {
              normal: normal_font_name,
              bold: bold_font_name
            }
          }
        end
        let(:font_file_filepath) { "/tmp/#{filename}" }
        let(:zip_file) do
          class_double("Zip::File").as_stubbed_const
        end
        let(:normal_font_file) do
          instance_double(
            "Zip::File", :normal_font_file, name: normal_font_name
          )
        end
        let(:bold_font_file) do
          instance_double(
            "Zip::File", :bold_font_file, name: bold_font_name
          )
        end
        let(:font_zip_file) { [normal_font_file, bold_font_file] }
        let(:normal_font_filepath) { "/tmp/#{normal_font_name}" }
        let(:bold_font_filepath) { "/tmp/#{bold_font_name}" }

        before do
          allow(zip_file).to \
            receive(:open).with(font_file_filepath).
              and_yield(font_zip_file)
          allow(FileSystem).to \
            receive(:tmpfile_path).with(filename).
              and_return(font_file_filepath)
          allow(FileSystem).to \
            receive(:tmpfile_path).with(normal_font_name).
              and_return(normal_font_filepath)
          allow(FileSystem).to \
            receive(:tmpfile_path).with(bold_font_name).
              and_return(bold_font_filepath)
          allow(normal_font_file).to \
            receive(:extract).with(normal_font_filepath)
          allow(bold_font_file).to \
            receive(:extract).with(bold_font_filepath)
          described_class.extract(font)
        end

        it "extracts all the font files" do
          expect(zip_file).to \
            have_received(:open).with(font_file_filepath)
          expect(FileSystem).to \
            have_received(:tmpfile_path).with(normal_font_name)
          expect(FileSystem).to \
            have_received(:tmpfile_path).with(bold_font_name)
          expect(normal_font_file).to \
            have_received(:extract).with(normal_font_filepath)
          expect(bold_font_file).to \
            have_received(:extract).with(bold_font_filepath)
        end
      end
    end
  end
end
