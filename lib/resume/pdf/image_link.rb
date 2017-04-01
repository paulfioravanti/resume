module Resume
  module PDF
    # Module representing faking out an image link in the PDF.
    #
    # @author Paul Fioravanti
    module ImageLink
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
        pdf.transparent(0) do
          pdf.formatted_text(
            [
              {
                text: "|" * logo[:bars],
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
