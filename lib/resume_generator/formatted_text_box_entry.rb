module ResumeGenerator
  module FormattedTextBoxEntry
    include Decoder

    private

    def position
      formatted_text_box_entry_for(
        d(data[:position]),
        data[:position_text_box_size],
        data[:at],
        data[:position_text_box_bottom_padding]
      )
    end

    def organisation
      formatted_text_box_entry_for(
        d(data[:organisation]),
        data[:organisation_text_box_size],
        data[:at],
        data[:organisation_text_box_bottom_padding]
      )
    end

    def period_and_location
      formatted_text_box_period_and_location(
        d(data[:period]),
        d(data[:location][:name]),
        d(data[:location][:link]),
        data[:at]
      )
    end

    def formatted_text_box_entry_for(item, size, at, bottom_padding)
      pdf.formatted_text_box(
        [formatted_entry_args_for(item, size)], at: [at, pdf.cursor]
      )
      pdf.move_down bottom_padding
    end

    def formatted_text_box_period_and_location(period, name, link, at)
      pdf.formatted_text_box(
        period_and_location_args_for(period, name, link),
        at: [at, pdf.cursor]
      )
    end
  end
end
