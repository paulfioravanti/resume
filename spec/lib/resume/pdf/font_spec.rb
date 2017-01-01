require "resume/pdf/font"

module Resume
  module PDF
    RSpec.describe Font do
      describe ".configure" do
        let(:font_families) { instance_double("Hash", :font_families) }
        let(:pdf) do
          instance_double(
            "Prawn::Document",
            :pdf,
            font_families: font_families
          )
        end
        let(:font_name) { "My Font" }
        let(:normal_font_file_path) { "/tmp/normal.ttf" }
        let(:bold_font_file_path) { "/tmp/bold.ttf" }
        let(:font) do
          {
            name: font_name,
            normal: normal_font_file_path,
            bold: bold_font_file_path
          }
        end

        context "when font is included in Prawn font built-ins" do
          let(:built_ins) { [font_name] }

          before do
            stub_const("Prawn::Font::AFM::BUILT_INS", built_ins)
            allow(Prawn::Font::AFM).to \
              receive(:hide_m17n_warning=).with(true)
            allow(pdf).to receive(:font).with(font_name)
            described_class.configure(pdf, font)
          end

          it "sets the PDF font to the selected font" do
            expect(Prawn::Font::AFM).to \
              have_received(:hide_m17n_warning=).with(true)
            expect(pdf).to have_received(:font).with(font_name)
          end
        end

        context "when font is not included in Prawn font built-ins" do
          let(:built_ins) { ["SomeOtherFont"] }
          let(:new_font) do
            {
              font_name => {
                normal: normal_font_file_path,
                bold: bold_font_file_path
              }
            }
          end

          before do
            stub_const("Prawn::Font::AFM::BUILT_INS", built_ins)
            allow(font_families).to receive(:update).with(new_font)
            allow(Prawn::Font::AFM).to \
              receive(:hide_m17n_warning=).with(true)
            allow(pdf).to receive(:font).with(font_name)
            described_class.configure(pdf, font)
          end

          it "updates the PDF font families with the new font" do
            expect(font_families).to have_received(:update).with(new_font)
            expect(Prawn::Font::AFM).to \
              have_received(:hide_m17n_warning=).with(true)
            expect(pdf).to have_received(:font).with(font_name)
          end
        end
      end
    end
  end
end
