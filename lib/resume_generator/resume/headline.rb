module ResumeGenerator
  module Resume
    class Headline
      include Decoder

      attr_reader :pdf, :primary, :secondary, :size

      def self.generate(pdf, headline)
        new(pdf, headline).generate
      end

      def initialize(pdf, headline)
        @pdf = pdf
        @primary = headline[:primary]
        @secondary = headline[:secondary]
        @size = headline[:size]
      end

      def generate
        pdf.formatted_text(
          [
            {
              text: d(primary[:text]),
              color: primary[:colour]
            },
            { text: d(secondary[:text]) }
          ],
          size: size
        )
      end
    end
  end
end

