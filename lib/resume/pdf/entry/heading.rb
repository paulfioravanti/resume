module Resume
  module PDF
    module Entry
      class Heading
        def self.generate(pdf, heading)
          new(
            pdf,
            top_padding: heading[:top_padding],
            text: heading[:text],
            styles: heading[:styles],
            colour: heading[:colour]
          ).generate
        end

        private_class_method :new

        def initialize(pdf, options)
          @pdf = pdf
          options.each do |attribute, value|
            instance_variable_set("@#{attribute}", value)
          end
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

        attr_reader :pdf, :top_padding, :text, :styles, :colour
      end
    end
  end
end
