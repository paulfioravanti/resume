module Resume
  # Namespace for all parts and functionality of the resume
  # PDF document.
  #
  # @author Paul Fioravanti
  module PDF
    # Module for configuration of fonts to use in the resume PDF document
    #
    # @author Paul Fioravanti
    module Font
      module_function

      # Configures the PDF font.
      #
      # @param pdf [Prawn::Document] The PDF to configure the font for.
      # @param font [Hash] Determines which font is needed for the PDF.
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
