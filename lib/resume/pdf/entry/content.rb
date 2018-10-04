require_relative "header"
require_relative "company_logo"

module Resume
  module PDF
    module Entry
      # Module for generating the content section of an entry.
      #
      # @author Paul Fioravanti
      module Content
        # Marker style for lists.
        LIST_MARKER = "-".freeze
        private_constant :LIST_MARKER

        module_function

        # Generates content for a job history entry.
        #
        # @param pdf [Prawn::Document]
        #   The PDF to on which to apply the content.
        # @param entry [Hash]
        #   Presentation information about the job history entry.
        def generate(pdf, entry)
          top_padding, logo, summary =
            entry.values_at(:top_padding, :logo, :summary)
          pdf.move_down(top_padding)
          Header.generate(pdf, entry)
          CompanyLogo.generate(pdf, logo)
          details(pdf, entry) if summary
        end

        def details(pdf, entry)
          top_padding, text = entry[:summary].values_at(:top_padding, :text)
          pdf.move_down(top_padding)
          pdf.text(text, inline_format: true)
          profile(pdf, entry)
        end
        private_class_method :details

        def profile(pdf, entry)
          return unless (job_content = entry[:profile])

          borders, height = entry[:cell_style].values_at(:borders, :height)
          table_data =
            job_content.reduce([]) do |content, responsibility|
              content << [LIST_MARKER, responsibility]
            end
          pdf.table(
            table_data, cell_style: { borders: borders, height: height }
          )
        end
        private_class_method :profile
      end
    end
  end
end
