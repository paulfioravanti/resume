module Resume
  module PDF
    class Headline

      def self.generate(pdf, headline)
        primary_header = headline[:primary]
        new(
          pdf,
          primary_text: Decoder.d(primary_header[:text]),
          primary_colour: primary_header[:colour],
          secondary_text: Decoder.d(headline[:secondary][:text]),
          size: headline[:size],
          top_padding: headline[:top_padding]
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
        pdf.formatted_text(
          [
            { text: primary_text, color: primary_colour },
            { text: secondary_text }
          ],
          size: size
        )
      end

      private

      attr_reader :pdf, :primary_text, :primary_colour,
                  :secondary_text, :size, :top_padding
    end
  end
end
