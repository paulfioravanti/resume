require_relative '../file_system'

module Resume
  module PDF
    class Font
      def self.configure(pdf, font)
        font_name = font[:name]
        unless Prawn::Font::AFM::BUILT_INS.include?(font_name)
          pdf.font_families.update(
            font_name => {
              normal: FileSystem.tmp_filepath(font[:normal]),
              bold: FileSystem.tmp_filepath(font[:bold])
            }
          )
        end
        pdf.font font_name
      end
    end
  end
end
