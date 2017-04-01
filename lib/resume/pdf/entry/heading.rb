module Resume
  module PDF
    # Namespace for generating PDF sections for job history entry.
    #
    # @author Paul Fioravanti
    module Entry
      # Module for generating the header section of the PDF.
      #
      # @author Paul Fioravanti
      module Heading
        module_function

        # Generates the PDF heading section.
        #
        # @param pdf [Prawn::Document]
        #   The PDF to on which to generate the heading.
        # @param heading [Hash]
        #   Presentation information about the heading.
        def generate(pdf, heading)
          pdf.move_down(heading[:top_padding])
          pdf.formatted_text([text_properties(heading)])
        end

        def text_properties(heading)
          {
            text: heading[:text],
            styles: heading[:styles],
            color: heading[:colour]
          }
        end
        private_class_method :text_properties
      end
    end
  end
end
