module Resume
  module PDF
    module Font
      module_function

      def configure(pdf, font)
        # Accented characters will bring up a
        # warning that we don't care about
        Prawn::Font::AFM.hide_m17n_warning = true
        font_name = font[:name]
        unless Prawn::Font::AFM::BUILT_INS.include?(font_name)
          update_font_families(pdf, font)
        end
        pdf.font font_name
      end

      def update_font_families(pdf, font)
        pdf.font_families.update(
          font[:name] => {
            normal: font[:normal],
            bold: font[:bold]
          }
        )
      end
      private_class_method :update_font_families
    end
  end
end
