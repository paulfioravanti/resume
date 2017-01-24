require_relative "entry/heading"

module Resume
  module PDF
    module TechnicalSkills
      module_function

      def generate(pdf, technical_skills)
        Entry::Heading.generate(pdf, technical_skills[:heading])
        content = technical_skills[:content]
        pdf.move_down(content[:top_padding])
        pdf.table(technical_skills(content), content[:properties])
      end

      def technical_skills(content)
        content[:skills].reduce([]) do |entries, (title, entry)|
          entries << [title, entry]
        end
      end
      private_class_method :technical_skills
    end
  end
end
