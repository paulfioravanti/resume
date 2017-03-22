module Resume
  module PDF
    module ImageLink
      module_function

      def generate(pdf, logo)
        image, fit, align, link_overlay_start =
          logo.values_at(:image, :fit, :align, :link_overlay_start)
        pdf.image(image, fit: fit, align: align)
        pdf.move_up(link_overlay_start)
        transparent_link(pdf, logo)
      end

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
