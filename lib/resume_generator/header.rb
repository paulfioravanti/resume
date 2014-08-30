require 'decodable'

module ResumeGenerator
  class Header
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
      if data[:at]
        text_box_header
      else
        text_header
      end
    end

    private

    def text_header
      formatted_text_entry_for(d(data[:position]), 12)
      formatted_text_entry_for(d(data[:organisation]), 11)
      formatted_text_period_and_location(
        d(data[:period]),
        d(data[:location][:name]),
        d(data[:location][:link])
      )
    end

    def text_box_header
      at = data[:at]
      formatted_text_box_entry_for(d(data[:position]), 12, at, 14)
      formatted_text_box_entry_for(d(data[:organisation]), 11, at, 13)
      formatted_text_box_period_and_location(
        d(data[:period]),
        d(data[:location][:name]),
        d(data[:location][:link]),
        at
      )
    end

    def formatted_text_entry_for(item, size)
      pdf.formatted_text(
        [formatted_entry_args_for(item, size)]
      )
    end

    def formatted_text_box_entry_for(item, size, at, value)
      pdf.formatted_text_box(
        [formatted_entry_args_for(item, size)], at: [at, pdf.cursor]
      )
      pdf.move_down value
    end

    def formatted_entry_args_for(string, size)
      { text: string, styles: [:bold], size: size }
    end

    def formatted_text_period_and_location(period, name, link)
      pdf.formatted_text(
        period_and_location_args_for(period, name, link)
      )
    end

    def formatted_text_box_period_and_location(period, name, link, at)
      pdf.formatted_text_box(
        period_and_location_args_for(period, name, link),
        at: [at, pdf.cursor]
      )
    end

    def period_and_location_args_for(period, name, link)
      [
        { text: period, color: '666666', size: 10 },
        { text: name, link: link, color: '666666', size: 10 }
      ]
    end
  end
end
