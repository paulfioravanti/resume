module ResumeGenerator
  module Resume
    class Headline
      include Decoder

      attr_reader :pdf, :primary_text, :primary_colour, :secondary_text, :size

      def self.generate(pdf, headline)
        new(pdf,
          headline[:primary][:text],
          headline[:primary][:colour],
          headline[:secondary][:text],
          headline[:size],
        ).generate
      end

      def generate
        pdf.formatted_text(
          [
            { text: d(primary_text), color: primary_colour },
            { text: d(secondary_text) }
          ],
          size: size
        )
      end

      private

      def initialize(pdf, primary_text, primary_colour, secondary_text, size)
        @pdf = pdf
        @primary_text = primary_text
        @primary_colour = primary_colour
        @secondary_text = secondary_text
        @size = size
      end
    end
  end
end

