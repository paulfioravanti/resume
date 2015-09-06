require 'resume/pdf/font'

module Resume
  module PDF
    RSpec.describe Font do
      describe '.configure' do
        let(:font_families) { instance_double('Hash', :font_families) }
        let(:pdf) do
          instance_double(
            'Prawn::Document',
            :pdf,
            font_families: font_families
          )
        end
        let(:font_name) { 'My Font' }
        let(:normal_font_file) { 'normal.ttf' }
        let(:bold_font_file) { 'bold.ttf' }
        let(:font) do
          {
            name: font_name,
            normal: normal_font_file,
            bold: bold_font_file
          }
        end

        context 'when selected font is included in Prawn font built-ins' do
          let(:built_ins) { [font_name] }

          before do
            stub_const('Prawn::Font::AFM::BUILT_INS', built_ins)
          end

          it 'sets the PDF font to the selected font' do
            expect(pdf).to receive(:font).with(font_name)
            described_class.configure(pdf, font)
          end
        end

        context 'when selected font is not included in Prawn font built-ins' do
          let(:built_ins) { ['SomeOtherFont'] }
          let(:normal_font_file_path) { "/tmp/#{normal_font_file}" }
          let(:bold_font_file_path) { "/tmp/#{normal_font_file}" }

          before do
            stub_const('Prawn::Font::AFM::BUILT_INS', built_ins)
            allow(FileSystem).to \
              receive(:tmpfile_path).with(normal_font_file).
                and_return(normal_font_file_path)
            allow(FileSystem).to \
              receive(:tmpfile_path).with(bold_font_file).
                and_return(bold_font_file_path)
          end

          it 'updates the PDF font families with the font and sets it' do
            expect(font_families).to receive(:update).with(
              font_name => {
                normal: normal_font_file_path,
                bold: bold_font_file_path
              }
            )
            expect(pdf).to receive(:font).with(font_name)
            described_class.configure(pdf, font)
          end
        end
      end
    end
  end
end
