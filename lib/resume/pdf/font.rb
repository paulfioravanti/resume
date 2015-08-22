require 'tmpdir'

module Resume
  module PDF
    class Font
      def self.configure(pdf, font)
        font_name = font[:name]
        unless Prawn::Font::AFM::BUILT_INS.include?(font_name)
          pdf.font_families.update(
            font_name => {
              normal: Resume.tmp_filepath(font[:normal]),
              bold: Resume.tmp_filepath(font[:bold])
            }
          )
        end
        pdf.font font_name
      end
    end
  end
end
