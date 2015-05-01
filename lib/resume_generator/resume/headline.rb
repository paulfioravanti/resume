module ResumeGenerator
  module Resume
    class Headline
      include Decoder

      attr_reader :pdf, :primary_text, :primary_colour, :secondary_text, :size

      def self.generate(pdf, headline)
        new(pdf, headline).generate
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

      def initialize(pdf, headline)
        @pdf = pdf
        @primary_text = headline[:primary][:text]
        @primary_colour = headline[:primary][:colour]
        @secondary_text = headline[:secondary][:text]
        @size = headline[:size]
      end
    end
  end
end

