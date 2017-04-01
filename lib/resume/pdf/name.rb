module Resume
  module PDF
    # Module representing the applicant name on the resume PDF
    #
    # @author Paul Fioravanti
    module Name
      module_function

      # Generates the applicant name on the PDF with specified
      # font, size, and text.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to set the applicant name for.
      # @param name [Hash]
      #   Contains data about presentation of the applicant name.
      def generate(pdf, name)
        pdf.font(name[:font], size: name[:size]) do
          pdf.text(name[:text])
        end
      end
    end
  end
end
