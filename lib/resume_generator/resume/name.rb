module ResumeGenerator
  module Resume
    class Name
      include Decoder

      attr_reader :pdf, :font, :size, :text

      def self.generate(pdf, name)
        new(pdf, name[:font], name[:size], name[:text]).generate
      end

      def generate
        pdf.font(font, size: size) do
          pdf.text d(text)
        end
      end

      private

      def initialize(pdf, name, size, text)
        @pdf = pdf
        @font = name
        @size = size
        @text = text
      end
    end
  end
end

