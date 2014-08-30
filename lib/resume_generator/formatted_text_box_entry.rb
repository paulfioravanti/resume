module ResumeGenerator
  module FormattedTextBoxEntry
    include Decodable

    private

    def position
      formatted_text_box_entry_for(d(data[:position]), 12, data[:at], 14)
    end

    def organisation
      formatted_text_box_entry_for(d(data[:organisation]), 11, data[:at], 13)
    end

    def period_and_location
      formatted_text_box_period_and_location(
        d(data[:period]),
        d(data[:location][:name]),
        d(data[:location][:link]),
        data[:at]
      )
    end

    def formatted_text_box_entry_for(item, size, at, value)
      pdf.formatted_text_box(
        [formatted_entry_args_for(item, size)], at: [at, pdf.cursor]
      )
      pdf.move_down value
    end

    def formatted_text_box_period_and_location(period, name, link, at)
      pdf.formatted_text_box(
        period_and_location_args_for(period, name, link),
        at: [at, pdf.cursor]
      )
    end
  end
end
