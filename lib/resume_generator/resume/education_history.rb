require 'singleton'

module ResumeGenerator
  module Resume
    class EducationHistory
      include Singleton

      attr_reader :pdf, :heading, :content

      def self.generate(pdf, data)
        new(pdf, data[:heading], data[:content]).generate
      end

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
      end
    end
  end
end

