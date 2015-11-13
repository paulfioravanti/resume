require_relative 'entry/heading'

module Resume
  module PDF
    class TechnicalSkills
      def self.generate(pdf, technical_skills)
        Entry::Heading.generate(pdf, technical_skills[:heading])
        content = technical_skills[:content]
        pdf.move_down content[:top_padding]
        skills = content[:skills].reduce([]) do |entries, (title, entry)|
          entries << [title, entry]
        end
        pdf.table(skills, content[:properties])
      end
    end
  end
end
