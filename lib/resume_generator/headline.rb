module ResumeGenerator
  class Headline
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
      pdf.formatted_text(
        [
          {
            text: d(data[:primary][:text]),
            color: data[:primary][:colour]
          },
          { text: d(data[:secondary][:text]) }
        ],
        size: data[:size]
      )
    end
  end
end
