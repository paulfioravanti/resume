module ResumeGenerator
  class Headline
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
      pdf.formatted_text(
        [
          {
            text: d(data[:ruby][:text]),
            color: data[:ruby][:colour]
          },
          { text: d(data[:other][:text]) }
        ],
        size: data[:size]
      )
    end
  end
end
