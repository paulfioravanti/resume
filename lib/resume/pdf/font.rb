module Resume
  module PDF
    class Font
      def self.configure(pdf, font)
        font_name = font[:name]
        unless Prawn::Font::AFM::BUILT_INS.include?(font_name)
          pdf.font_families.update(
            font_name => {
              normal: font[:normal],
              bold: font[:bold]
            }
          )
        end
        # Accented characters will bring up a warning that we don't
        # care about
        Prawn::Font::AFM.hide_m17n_warning = true
        pdf.font font_name
      end
    end
  end
end
