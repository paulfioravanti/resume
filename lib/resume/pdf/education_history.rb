require_relative "entry/heading"
require_relative "entry/content"

module Resume
  module PDF
    # Module representing the Education History section of the PDF resume.
    #
    # @author Paul Fioravanti
    module EducationHistory
      module_function

      # Generates the Education History section of the PDF.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to on which to apply the education history section.
      # @param education_history [Hash]
      #   Presentation information about the education history section.
      def generate(pdf, education_history)
        Entry::Heading.generate(pdf, education_history[:heading])
        education_history.dig(:content, :entries).values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
      end
    end
  end
end
