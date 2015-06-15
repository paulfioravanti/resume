require_relative 'entry/content'

module Resume
  module PDF
    class EmploymentHistory

      attr_reader :pdf, :heading, :content

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

      def generate_heading
        Entry::Heading.generate(pdf, heading)
      end

      def generate_content
        content[:entries].values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
        pdf.move_down content[:bottom_padding]
        pdf.stroke_horizontal_rule { color content[:horizontal_rule_colour] }
      end
    end
  end
end
