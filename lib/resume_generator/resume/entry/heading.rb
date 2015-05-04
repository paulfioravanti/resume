require 'singleton'

module ResumeGenerator
  module Resume
    module Entry
      class Heading
        include Singleton, Decoder

        attr_reader :pdf, :top_padding, :text, :styles, :colour

        def self.generate(pdf, heading)
          new(
            pdf,
            top_padding: heading[:top_padding],
            text: d(heading[:text]),
            styles: heading[:styles].map(&:to_sym),
            colour: heading[:colour]
          ).generate
        end

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
      end
    end
  end
end
