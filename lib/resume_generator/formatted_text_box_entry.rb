require 'decodable'

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

    def formatted_text_box_entry_for(item, size, at, value)
      pdf.formatted_text_box(
        [formatted_entry_args_for(item, size)], at: [at, pdf.cursor]
      )
      pdf.move_down value
    end

    def period_and_location
      pdf.formatted_text_box(
        period_and_location_args_for(
          d(data[:period]),
          d(data[:location][:name]),
          d(data[:location][:link]),
        ),
        at: [data[:at], pdf.cursor]
      )
    end
  end
end
