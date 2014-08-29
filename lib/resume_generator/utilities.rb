module ResumeGenerator
  module Utilities
    private

    def transparent_link(pdf, resource)
      pdf.transparent(0) do
        pdf.formatted_text(
          [
            {
              text: '|' * resource.bars,
              size: resource.size,
              link: resource.link
            }
          ], align: resource.align
        )
      end
    end
  end
end
