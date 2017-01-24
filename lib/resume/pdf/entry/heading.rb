module Resume
  module PDF
    module Entry
      module Heading
        module_function

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
