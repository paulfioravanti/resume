module Resume
  module PDF
    class Name
      include Decoder

      def self.generate(pdf, name)
        new(
          pdf,
          font: name[:font],
          size: name[:size],
          text: d(name[:text])
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
        pdf.font(font, size: size) do
          pdf.text(text)
        end
      end

      private

      attr_reader :pdf, :font, :size, :text
    end
  end
end
