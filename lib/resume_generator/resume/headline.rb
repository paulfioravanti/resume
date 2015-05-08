module ResumeGenerator
  module Resume
    class Headline
      include Decoder

      attr_reader :pdf, :primary_text, :primary_colour, :secondary_text, :size

      def self.generate(pdf, headline)
        new(
          pdf,
          primary_text: d(headline[:primary][:text]),
          primary_colour: headline[:primary][:colour],
          secondary_text: d(headline[:secondary][:text]),
          size: headline[:size],
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
        pdf.formatted_text(
          [
            { text: primary_text, color: primary_colour },
            { text: secondary_text }
          ],
          size: size
        )
      end
    end
  end
end

