module Resume
  module PDF
    module TransparentLink
      def self.extended(base)
        base.send(:private_class_method, :transparent_link)
      end

      private

      def transparent_link(pdf, logo)
        pdf.transparent(0) do
          pdf.formatted_text(
            [
              {
                text: '|' * logo[:bars],
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
