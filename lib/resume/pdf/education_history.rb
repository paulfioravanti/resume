module Resume
  module PDF
    class EducationHistory

      def self.generate(pdf, data)
        new(pdf, data[:heading], data[:content]).generate
      end

      private_class_method :new

      def initialize(pdf, heading, content)
        @pdf = pdf
        @heading = heading
        @content = content
      end

      def generate
        generate_heading
        generate_content
      end

      private

      attr_reader :pdf, :heading, :content

      def generate_heading
        Entry::Heading.generate(pdf, heading)
      end

      def generate_content
        content[:entries].values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
      end
    end
  end
end
