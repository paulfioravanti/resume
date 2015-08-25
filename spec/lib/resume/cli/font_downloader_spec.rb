require 'resume/cli/font_downloader'

module Resume
  module CLI
    RSpec.describe FontDownloader do
      let(:font_downloader) { described_class.new(fonts) }

      describe '#audit_font_dependencies' do
        context 'when font dependencies are not present' do
          let(:fonts) { {} }

        end

        context 'when font dependencies are present' do
          context 'when all font files are available on the system' do
            it 'empties the list of font dependencies' do

            end
          end

          context 'when any font files are missing from the system' do
            it 'leaves those fonts in the dependencies list' do

            end
          end
        end
      end

      describe '#output_font_dependencies' do
        context 'when there are no font dependencies' do
          it 'does nothing' do

          end
        end

        context 'when there are font dependencies' do
          it 'informs that custom fonts must be installed' do

          end
        end
      end

      describe '#fonts_sucessfully_downloaded?' do
        context 'when there are no font dependencies' do
          it 'returns true' do

          end
        end

        context 'when there are font dependencies' do
          context 'when all fonts are successfully downloaded and extracted' do
            it 'returns true' do

            end
          end

          context 'when an error occurs during font download' do
            it 'returns false' do

            end
          end
        end
      end
    end
  end
end
