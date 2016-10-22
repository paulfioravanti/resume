require "resume/cli/content_parser"

module Resume
  module CLI
    RSpec.describe ContentParser do
      describe ".decode_content" do
        let(:string) { "Some string" }

        before do
          allow(Base64).to \
            receive(:strict_decode64).with(string).and_return(string)
        end

        it "decodes the string and forces encoding to UTF-8" do
          expect(string).to receive(:force_encoding).with("utf-8")
          described_class.decode_content(string)
        end
      end

      describe ".parse" do
        let(:parse_object) { described_class.parse(object) }

        context "when object is a Hash" do
          context "when hash key is :align" do
            let(:object) { { align: "value" } }
            let(:parsed_object) { { align: :value } }

            it "converts the value into a symbol" do
              expect(parse_object).to eq(parsed_object)
            end
          end

          context "when hash is the font configuration" do
            let(:normal_font_filename) { "ipamp.ttf" }
            let(:bold_font_filename) { "ipagp.ttf" }
            let(:object) do
              {
                font: {
                  name: "IPA",
                  normal: normal_font_filename,
                  bold: bold_font_filename
                }
              }
            end
            let(:normal_tmpfile_path) do
              "/tmp/#{normal_font_filename}"
            end
            let(:bold_tmpfile_path) do
              "/tmp/#{bold_font_filename}"
            end
            let(:parsed_object) do
              {
                font: {
                  name: "IPA",
                  normal: normal_tmpfile_path,
                  bold: bold_tmpfile_path
                }
              }
            end

            before do
              allow(FileSystem).to \
                receive(:tmpfile_path).with(normal_font_filename).
                  and_return(normal_tmpfile_path)
              allow(FileSystem).to \
                receive(:tmpfile_path).with(bold_font_filename).
                  and_return(bold_tmpfile_path)
            end

            it "substitutes out the font name for its tempfile path" do
              expect(parse_object).to eq(parsed_object)
            end
          end

          context "when hash value is a Base64 string" do
            let(:object) { { key: base64_string } }

            context "when hash value is not a reserved word" do
              let(:base64_string) { "RW5jb2RlZA==" }
              let(:parsed_object) { { key: "Encoded" } }

              it "decodes the hash value" do
                expect(parse_object).to eq(parsed_object)
              end
            end
          end

          context "when hash value is an asset file" do
            let(:asset_file_path) do
              "https://www.dropbox.com/s/xxx/file.jpg?dl=1"
            end
            let(:object) { { key: asset_file_path } }
            let(:file) { instance_double("File", :asset_file) }
            let(:parsed_object) { { key: file } }

            before do
              allow(FileFetcher).to \
                receive(:fetch).with(asset_file_path).
                  and_return(file)
            end

            it "replaces the file path with the file object" do
              expect(parse_object).to eq(parsed_object)
            end
          end

          context "when hash value is a standard string" do
            let(:object) { { key: "A standard string" } }

            it "returns the object unchanged" do
              expect(parse_object).to eq(object)
            end
          end
        end

        context "when object is an Array" do
          let(:object) { [value] }

          context "when array value is a Base64 string" do
            context "when array value is not a reserved word" do
              let(:value) { "RW5jb2RlZA==" }
              let(:parsed_object) { ["Encoded"] }

              it "decodes the array value" do
                expect(parse_object).to eq(parsed_object)
              end
            end
          end

          context "when array value is not a Base64 string" do
            let(:value) { "A string" }

            it "returns the object unchanged" do
              expect(parse_object).to eq(object)
            end
          end
        end

        context "when object is neither a Hash nor an Array" do
          let(:object) { "A string" }

          it "returns the object unchanged" do
            expect(parse_object).to eq(object)
          end
        end
      end
    end
  end
end
