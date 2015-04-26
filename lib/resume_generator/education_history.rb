module ResumeGenerator
  class EducationHistory
    include Decodable

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
      data[:entries].each do |_, entry|
        Listing.generate(pdf, entry)
      end
    end
  end
end
