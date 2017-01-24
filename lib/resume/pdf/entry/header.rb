module Resume
  module PDF
    module Entry
      module Header
        module_function

        def generate(pdf, entry)
          # Different rendering behaviour needed depending on whether
          # the header is being drawn from left to right on the page
          # or specifically placed at a location on the x-axis
          header_sections = [
            [entry[:position]],
            [entry[:organisation]],
            [entry[:period], entry[:location]]
          ]
          if (x_position = entry[:at_x_position])
            formatted_text_box_header(header_sections, pdf, x_position)
          else
            formatted_text_header(header_sections, pdf)
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
