module ResumeGenerator
  module Resume
    class Name
      include Decoder

      attr_reader :pdf, :data

      def self.generate(pdf, data)
        new(pdf, data).generate
      end

      def initialize(pdf, data)
        @pdf = pdf
        @data = data
      end

      def generate
        pdf.font(data[:font], size: data[:size]) do
          pdf.text d(data[:text])
        end
      end
    end
  end
end

