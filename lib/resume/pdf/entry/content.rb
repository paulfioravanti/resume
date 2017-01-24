require_relative "header"
require_relative "company_logo"

module Resume
  module PDF
    module Entry
      module Content
        module_function

        def generate(pdf, entry)
          pdf.move_down(entry[:top_padding])
          Header.generate(pdf, entry)
          CompanyLogo.generate(pdf, entry[:logo])
          details(pdf, entry) if entry.key?(:summary)
        end

        def details(pdf, entry)
          pdf.move_down(entry.dig(:summary, :top_padding))
          pdf.text(entry.dig(:summary, :text), inline_format: true)
          profile(pdf, entry)
        end
        private_class_method :details

        def profile(pdf, entry)
          return unless (job_content = entry[:profile])
          cell_style = entry[:cell_style]
          table_data =
            job_content.reduce([]) do |content, responsibility|
              content << ["-", responsibility]
            end
          pdf.table(
            table_data,
            cell_style: {
              borders: cell_style[:borders],
              height: cell_style[:height]
            }
          )
        end
        private_class_method :profile
      end
    end
  end
end
