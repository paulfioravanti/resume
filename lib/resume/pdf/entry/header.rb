module Resume
  module PDF
    module Entry
      # Module for generating a header for an entry.
      #
      # @author Paul Fioravanti
      module Header
        module_function

        # Generates the header section for a job history entry.
        #
        # @param pdf [Prawn::Document]
        #   The PDF to on which to apply the header.
        # @param entry [Hash]
        #   Presentation information about the job history entry.
        def generate(pdf, entry)
          # Different rendering behaviour needed depending on whether
          # the header is being drawn from left to right on the page
          # or specifically placed at a location on the x-axis
          entry_header_sections = header_sections(entry)
          if (x_position = entry[:at_x_position])
            formatted_text_box_header(entry_header_sections, pdf, x_position)
          else
            formatted_text_header(entry_header_sections, pdf)
          end
        end

        def formatted_text_box_header(header_sections, pdf, x_position)
          header_sections.each do |sections|
            pdf.formatted_text_box(
              sections.map { |section| properties_for(section) },
              at: [x_position, pdf.cursor]
            )
            pdf.move_down(sections.first[:bottom_padding])
          end
        end
        private_class_method :formatted_text_box_header

        def formatted_text_header(header_sections, pdf)
          header_sections.each do |sections|
            pdf.formatted_text(
              sections.map { |section| properties_for(section) }
            )
          end
        end
        private_class_method :formatted_text_header

        def header_sections(entry)
          [
            [entry[:position]],
            [entry[:organisation]],
            [entry[:period], entry[:location]]
          ]
        end
        private_class_method :header_sections

        def properties_for(section)
          {
            text: section[:text],
            styles: section[:styles],
            size: section[:size],
            color: section[:colour],
            link: section[:link]
          }
        end
        private_class_method :properties_for
      end
    end
  end
end
