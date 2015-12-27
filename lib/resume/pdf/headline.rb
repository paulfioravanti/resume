module Resume
  module PDF
    class Headline
      def self.generate(pdf, headline)
        pdf.move_down(headline[:top_padding])
        primary_header = headline[:primary]
        pdf.formatted_text(
          [
            {
              text: primary_header[:text],
              color: primary_header[:colour]
            },
            { text: headline.dig(:secondary, :text) }
          ],
          size: headline[:size]
        )
      end
    end
  end
end
