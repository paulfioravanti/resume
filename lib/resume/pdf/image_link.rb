module Resume
  module PDF
    # Module representing faking out an image link in the PDF.
    #
    # @author Paul Fioravanti
    module ImageLink
      # The character to be used as filler when placed over images
      # to make a transparent link.
      BAR = "|".freeze
      private_constant :BAR
      # Level of opaqueness for an image link.
      TRANSPARENT = 0
      private_constant :TRANSPARENT

      module_function

      # Generates an image link on the PDF document.
      # This is done for social media, company, and educational
      # institution logos.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to on which to apply the image link.
      # @param logo [Hash]
      #   Presentation information about the target logo for an image link.
      def generate(pdf, logo)
        image, fit, align, link_overlay_start =
          logo.values_at(:image, :fit, :align, :link_overlay_start)
        pdf.image(image, fit: fit, align: align)
        pdf.move_up(link_overlay_start)
        transparent_link(pdf, logo)
      end

      # Generates a set of transparent "bars" (|||) over
      # a section of a PDF document.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to on which to apply the transparent link.
      # @param logo [Hash]
      #   Presentation information about the target logo.
      def transparent_link(pdf, logo)
        pdf.transparent(TRANSPARENT) do
          pdf.formatted_text(
            [
              {
                text: BAR * logo[:bars],
                size: logo[:size],
                link: logo[:link]
              }
            ], align: logo[:align]
          )
        end
      end
    end
  end
end
