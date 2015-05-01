module ResumeGenerator
  module Resume
    module Entry
      class Heading
        extend Decoder

        attr_reader :pdf, :top_padding, :text, :styles, :colour

        def self.generate(pdf, heading)
          new(
            pdf,
            heading[:top_padding],
            d(heading[:text]),
            heading[:styles].map(&:to_sym),
            heading[:colour]
          ).generate
        end

        def generate
          pdf.move_down(top_padding)
          pdf.formatted_text([{
            text: text,
            styles: styles,
            color: colour
          }])
        end

        private

        def initialize(pdf, top_padding, text, styles, colour)
          @pdf = pdf
          @top_padding = top_padding
          @text = text
          @styles = styles
          @colour = colour
        end
      end
    end
  end
end
