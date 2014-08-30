module ResumeGenerator
  module FormattedTextEntry
    include Decodable

    private

    def position
      formatted_text_entry_for(d(data[:position]), 12)
    end

    def organisation
      formatted_text_entry_for(d(data[:organisation]), 11)
    end

    def period_and_location
      formatted_text_period_and_location(
        d(data[:period]),
        d(data[:location][:name]),
        d(data[:location][:link])
      )
    end

    def formatted_text_entry_for(item, size)
      pdf.formatted_text(
        [formatted_entry_args_for(item, size)]
      )
    end

    def formatted_text_period_and_location(period, name, link)
      pdf.formatted_text(
        period_and_location_args_for(period, name, link)
      )
    end
  end
end
