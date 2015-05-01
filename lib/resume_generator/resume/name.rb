module ResumeGenerator
  module Resume
    class Name
      include Decoder

      attr_reader :pdf, :font, :size, :text

      def self.generate(pdf, name)
        new(pdf, name).generate
      end

      def generate
        pdf.font(font, size: size) do
          pdf.text d(text)
        end
      end

      private

      def initialize(pdf, name)
        @pdf = pdf
        @font = name[:font]
        @size = name[:size]
        @text = name[:text]
      end
    end
  end
end

