module Resume
  module PDF
    module TransparentLink
      module_function

      def generate(pdf, logo)
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
