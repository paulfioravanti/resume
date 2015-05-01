module ResumeGenerator
  module Resume
    class TechnicalSkills
      include Decoder

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
        pdf.move_down heading[:top_padding]
        pdf.formatted_text([{
          text: d(heading[:text]),
          styles: heading[:styles].map(&:to_sym),
          color: heading[:colour]
        }])
      end

      def generate_content
        pdf.move_down content[:top_padding]
        skills = content[:skills].reduce([]) do |entries, entry|
          entries << [d(entry.first), d(entry.last)]
        end
        pdf.table(skills, content[:properties])
      end
    end
  end
end

