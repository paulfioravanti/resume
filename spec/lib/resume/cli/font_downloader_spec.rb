require 'resume/cli/font_downloader'

module Resume
  module CLI
    RSpec.describe FontDownloader do
      let(:font_downloader) { described_class.new(fonts) }

      describe '#audit_font_dependencies' do
        context 'when font dependencies are not present' do
          let(:fonts) { [] }

          before { font_downloader.audit_font_dependencies }

          it 'does nothing to the empty set of fonts' do
            expect(font_downloader.fonts).to be_empty
          end
        end

        context 'when font dependencies are present' do
          let(:normal_font_name) { 'ipamp.ttf' }
          let(:bold_font_name) { 'ipagp.ttf' }
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

          context 'when required font file is available on the system' do
            before do
              allow(File).to \
                receive(:file?).with(normal_font_filepath).
                  and_return(true)
              allow(File).to \
                receive(:file?).with(bold_font_filepath).
                  and_return(true)
              font_downloader.audit_font_dependencies
            end

            it 'removes the font from the list of font dependencies' do
              expect(font_downloader.fonts).to_not include(font)
            end
          end

          context 'when required font file is missing from the system' do
            before do
              allow(File).to \
                receive(:file?).with(normal_font_filepath).
                  and_return(true)
              allow(File).to \
                receive(:file?).with(bold_font_filepath).
                  and_return(false)
              font_downloader.audit_font_dependencies
            end

            it 'leaves those fonts in the dependencies list' do
              expect(font_downloader.fonts).to include(font)
            end
          end
        end
      end

      describe '#output_font_dependencies' do
        context 'when there are no font dependencies' do
          let(:fonts) { [] }

          it 'outputs nothing' do
            expect(Output).to_not receive(:warning)
            font_downloader.output_font_dependencies
          end
        end

        context 'when there are font dependencies' do
          # there are fonts: we don't care what they are
          let(:fonts) { [{}] }

          it 'informs that custom fonts must be installed' do
            expect(Output).to receive(:warning).with(:custom_fonts)
            font_downloader.output_font_dependencies
          end
        end
      end

      describe '#fonts_sucessfully_downloaded?' do
        let(:fonts_successfully_downloaded) do
          font_downloader.fonts_successfully_downloaded?
        end

        context 'when there are no font dependencies' do
          let(:fonts) { [] }

          it 'returns true' do
            expect(fonts_successfully_downloaded).to be true
          end
        end

        context 'when there are font dependencies' do
          let(:font_location) do
            'http://ipafont.ipa.go.jp/ipafont/IPAfont00303.php'
          end
          let(:filename) { 'IPAfont00303.zip' }
          let(:normal_font_name) { 'ipamp.ttf' }
          let(:bold_font_name) { 'ipagp.ttf' }
          let(:font) do
            {
              location: font_location,
              filename: filename,
              files: {
                normal: normal_font_name,
                bold: bold_font_name
              }
            }
          end
          let(:fonts) { [font] }

          context 'when all fonts are successfully downloaded and extracted' do
            # For the most part, mocking this out is complete madness,
            # but I didn't want the test suite to be dependent on the
            # rubyzip gem since it's not used to generate all resumes
            let(:font_file_filepath) { "/tmp/#{filename}" }
            let(:font_file) { double('font_file') }
            let(:zip_file) { double('Zip::File') }
            let(:normal_font_file) do
              double('normal_font_file', name: normal_font_name)
            end
            let(:bold_font_file) do
              double('bold_font_file', name: bold_font_name)
            end
            let(:font_zip_file) { [ normal_font_file, bold_font_file ] }
            let(:normal_font_filepath) { "/tmp/#{normal_font_name}" }
            let(:bold_font_filepath) { "/tmp/#{bold_font_name}" }

            before do
              expect(FileFetcher).to \
                receive(:fetch).with(
                  font_location,
                  filename: filename,
                  mode: 'wb'
                )
              allow(FileSystem).to \
                receive(:tmpfile_path).with(filename).
                  and_return(font_file_filepath)
              allow(font_downloader).to receive(:require).with('zip')
              stub_const('Zip::File', zip_file)
              allow(zip_file).to \
                receive(:open).with(font_file_filepath).
                  and_yield(font_zip_file)
              allow(FileSystem).to \
                receive(:tmpfile_path).with(normal_font_name).
                  and_return(normal_font_filepath)
              allow(FileSystem).to \
                receive(:tmpfile_path).with(bold_font_name).
                  and_return(bold_font_filepath)
              expect(Output).to \
                receive(:plain).with([
                  :downloading_font,
                  { filename: filename, location: font_location }
                ])
              expect(normal_font_file).to \
                receive(:extract).
                  with(normal_font_filepath) do |*args, &block|
                    expect(block.call).to be true
                  end
              expect(bold_font_file).to \
                receive(:extract).
                  with(bold_font_filepath) do |*args, &block|
                    expect(block.call).to be true
                  end
            end

            it 'returns true' do
              expect(fonts_successfully_downloaded).to be true
            end
          end

          context 'when an error occurs during font download' do
            before do
              allow(font_downloader).to \
                receive(:download_font_file).with(font).
                  and_raise(NetworkConnectionError)
              expect(Output).to \
                receive(:plain).with([
                  :downloading_font,
                  { filename: filename, location: font_location }
                ])
            end

            it 'returns false' do
              expect(fonts_successfully_downloaded).to be false
            end
          end
        end
      end
    end
  end
end
