require 'utilities'

module ResumeGenerator
  # Methods are deliberately named obscurely to negate keyword indexing in
  # online code repositories, but they represent each entry in the
  # Employment History section
  module Employable
    include Utilities

    def employment_listing_for(entry)
      header_for(entry)
      logo_link_for(entry)
      details_for(entry)
    end

    private

    def details_for(entry)
      move_down entry[:y_details_start] || 10
      summary(entry[:summary])
      profile(entry[:profile])
    end

    def summary(string)
      text(d(string), inline_format: true)
    end

    def profile(items)
      return unless items
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [], height: "21" })
    end
  end
end