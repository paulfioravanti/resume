module Resume
  module PDF
    module Entry
      class Heading
        def self.generate(pdf, heading)
          pdf.move_down(heading[:top_padding])
          pdf.formatted_text([{
            text: heading[:text],
            styles: heading[:styles],
            color: heading[:colour]
          }])
        end
      end
    end
  end
end
