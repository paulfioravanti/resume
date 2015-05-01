module ResumeGenerator
  module Resume
    class Name
      include Decoder

      attr_reader :pdf, :name

      def self.generate(pdf, name)
        new(pdf, name).generate
      end

      def initialize(pdf, name)
        @pdf = pdf
        @name = name
      end

      def generate
        pdf.font(name[:font], size: name[:size]) do
          pdf.text d(name[:text])
        end
      end
    end
  end
end

