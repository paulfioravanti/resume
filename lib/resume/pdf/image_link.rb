module Resume
  module PDF
    module ImageLink
      module_function

      def generate(pdf, logo)
        pdf.image(logo[:image], fit: logo[:fit], align: logo[:align])
        pdf.move_up logo[:link_overlay_start]
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
