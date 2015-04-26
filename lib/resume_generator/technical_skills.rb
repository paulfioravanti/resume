module ResumeGenerator
  class TechnicalSkills
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
      heading
      content
    end

    private

    def heading
      pdf.move_down data[:top_padding]
      pdf.formatted_text([{
        text: d(data[:heading]),
        styles: data[:heading_styles].map(&:to_sym),
        color: data[:heading_colour]
      }])
    end

    def content
      pdf.move_down data[:content_top_padding]
      table_data = data[:content].reduce([]) do |content, entry|
        content << [d(entry.first), d(entry.last)]
      end
      pdf.table(table_data, data[:properties])
    end
  end
end
