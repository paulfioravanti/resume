require "resume/cli/font_downloader"

module Resume
  module CLI
    RSpec.describe FontDownloader do
      let(:font_downloader) { described_class.new(fonts) }

      describe "#audit_font_dependencies" do
        context "when font dependencies are not present" do
          let(:fonts) { [] }

          before { font_downloader.audit_font_dependencies }

          it "does nothing to the empty set of fonts" do
            expect(font_downloader.fonts).to be_empty
          end
        end

        context "when font dependencies are present" do
          let(:normal_font_name) { "ipamp.ttf" }
          let(:bold_font_name) { "ipagp.ttf" }
          let(:font) do
            {
              files: {
                normal: normal_font_name,
                bold: bold_font_name
              }
            }
          end
          let(:fonts) { [font] }
          let(:normal_font_filepath) { "/tmp/#{normal_font_name}" }
          let(:bold_font_filepath) { "/tmp/#{bold_font_name}" }

          before do
            allow(FileSystem).to \
              receive(:tmpfile_path).with(normal_font_name).
                and_return(normal_font_filepath)
            allow(FileSystem).to \
              receive(:tmpfile_path).with(bold_font_name).
                and_return(bold_font_filepath)
          end

          context "when required font file available on the system" do
            before do
              allow(File).to \
                receive(:file?).with(normal_font_filepath).
                  and_return(true)
              allow(File).to \
                receive(:file?).with(bold_font_filepath).
                  and_return(true)
              font_downloader.audit_font_dependencies
            end

            it "removes the font from the list of font dependencies" do
              expect(font_downloader.fonts).not_to include(font)
            end
          end

          context "when required font file missing from the system" do
            before do
              allow(File).to \
                receive(:file?).with(normal_font_filepath).
                  and_return(true)
              allow(File).to \
                receive(:file?).with(bold_font_filepath).
                  and_return(false)
              font_downloader.audit_font_dependencies
            end

            it "leaves those fonts in the dependencies list" do
              expect(font_downloader.fonts).to include(font)
            end
          end
        end
      end

      describe "#output_font_dependencies" do
        context "when there are no font dependencies" do
          let(:fonts) { [] }

          before do
            allow(Output).to receive(:warning)
            font_downloader.output_font_dependencies
          end

          it "outputs nothing" do
            expect(Output).not_to have_received(:warning)
          end
        end

        context "when there are font dependencies" do
          # there are fonts: we don"t care what they are
          let(:fonts) { [{}] }

          before do
            allow(Output).to receive(:warning).with(:custom_fonts)
            font_downloader.output_font_dependencies
          end

          it "informs that custom fonts must be installed" do
            expect(Output).to have_received(:warning).with(:custom_fonts)
          end
        end
      end

      describe "#fonts_sucessfully_downloaded?" do
        let(:fonts_successfully_downloaded) do
          font_downloader.fonts_successfully_downloaded?
        end

        context "when there are no font dependencies" do
          let(:fonts) { [] }

          it "returns true" do
            expect(fonts_successfully_downloaded).to be true
          end
        end

        context "when there are font dependencies" do
          let(:font_location) do
            "aHR0cHM6Ly93d3cuZHJvcGJveC5jb20vcy94eHg" \
              "vZm9udHMuemlwP2RsPTE="
          end
          let(:decoded_font_location) do
            "https://www.dropbox.com/s/xxx/fonts.zip?dl=1"
          end
          let(:font) do
            { location: font_location }
          end
          let(:fonts) { [font] }

          context "when all fonts successfully downloaded and extracted" do
            before do
              allow(Output).to \
                receive(:plain).with(:downloading_font)
              allow(FileFetcher).to \
                receive(:fetch).with(decoded_font_location)
              allow(font_downloader).to receive(:require).with("zip")
              allow(FontExtractor).to receive(:extract).with(font)
            end

            it "returns true" do
              expect(fonts_successfully_downloaded).to be true
              expect(Output).to \
                have_received(:plain).with(:downloading_font)
              expect(FileFetcher).to \
                have_received(:fetch).with(decoded_font_location)
              expect(FontExtractor).to have_received(:extract).with(font)
            end
          end

          context "when an error occurs during font download" do
            before do
              allow(Output).to \
                receive(:plain).with(:downloading_font)
              allow(FileFetcher).to \
                receive(:fetch).and_raise(NetworkConnectionError)
            end

            it "returns false" do
              expect(fonts_successfully_downloaded).to be false
              expect(Output).to \
                have_received(:plain).with(:downloading_font)
            end
          end
        end
      end
    end
  end
end
