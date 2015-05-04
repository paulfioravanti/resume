require 'singleton'

module ResumeGenerator
  module Resume
    class Name
      include Singleton, Decoder

      attr_reader :pdf, :font, :size, :text

      def self.generate(pdf, name)
        new(
          pdf,
          font: name[:font],
          size: name[:size],
          text: d(name[:text])
        ).generate
      end

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
    end
  end
end

