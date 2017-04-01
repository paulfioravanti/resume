module Resume
  module PDF
    # Module representing the headline section of the resume,
    # just below the applicant name.
    #
    # @author Paul Fioravanti
    module Headline
      module_function

      # Generates the headline for the PDF.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to on which to apply the headline.
      # @param headline [Hash]
      #   Presentation information about the headline.
      def generate(pdf, headline)
        pdf.move_down(headline[:top_padding])
        primary_header = headline[:primary]
        pdf.formatted_text(
          [
            {
              text: primary_header[:text],
              color: primary_header[:colour]
            },
            { text: headline.dig(:secondary, :text) }
          ],
          size: headline[:size]
        )
      end
    end
  end
end
