module Resume
  module PDF
    module Entry
      # Module for generating a company logo for an entry.
      #
      # @author Paul Fioravanti
      module CompanyLogo
        module_function

        # Generates a company logo for an entry.
        #
        # @param pdf [Prawn::Document]
        #   The PDF to on which to apply the company logo.
        # @param logo [Hash]
        #   Presentation information about the logo.
        def generate(pdf, logo)
          pdf.move_up logo[:y_start]
          pdf.bounding_box(
            [logo[:origin], pdf.cursor],
            width: logo[:width], height: logo[:height]
          ) do
            ImageLink.generate(pdf, logo)
          end
        end
      end
    end
  end
end
