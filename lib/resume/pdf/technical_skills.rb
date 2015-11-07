require_relative '../decoder'
require_relative 'entry/heading'

module Resume
  module PDF
    class TechnicalSkills
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
        pdf.move_down content[:top_padding]
        skills = content[:skills].reduce([]) do |entries, (title, content)|
          entries << [title, content]
        end
        pdf.table(skills, content[:properties])
      end
    end
  end
end
