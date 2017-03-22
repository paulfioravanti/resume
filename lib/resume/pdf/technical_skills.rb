require_relative "entry/heading"

module Resume
  module PDF
    module TechnicalSkills
      module_function

      def generate(pdf, technical_skills)
        heading, content = technical_skills.values_at(:heading, :content)
        Entry::Heading.generate(pdf, heading)
        generate_table(pdf, content)
      end

      def generate_table(pdf, content)
        top_padding, properties = content.values_at(:top_padding, :properties)
        pdf.move_down(top_padding)
        pdf.table(technical_skills(content), properties)
      end
      private_class_method :generate_table

      def technical_skills(content)
        content[:skills].reduce([]) do |entries, (title, entry)|
          entries << [title, entry]
        end
      end
      private_class_method :technical_skills
    end
  end
end
