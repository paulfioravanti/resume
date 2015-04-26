module ResumeGenerator
  class TechnicalSkills
    include Decoder

    attr_reader :pdf, :heading, :content

    def self.generate(pdf, data)
      new(pdf, data).generate
    end

    def initialize(pdf, data)
      @pdf = pdf
      @heading = data[:heading]
      @content = data[:content]
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
      skills = content[:skills].reduce([]) do |data, entry|
        data << [d(entry.first), d(entry.last)]
      end
      pdf.table(skills, content[:properties])
    end
  end
end
