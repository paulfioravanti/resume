require 'utilities'

module ResumeGenerator
  module Employable
    include Utilities

    def rc(entry)
      header_text_for(entry, 10)
      organisation_logo_for(entry, :rc)
      content_for(entry)
    end

    def fl(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :fl)
      content_for(entry, 15)
    end

    def gw(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :gw)
      content_for(entry)
    end

    def rnt(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :rnt)
      content_for(entry)
    end

    def sra(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :sra)
      content_for(entry)
    end

    def jet(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :jet)
      content_for(entry)
    end

    def satc(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :satc)
      content_for(entry)
    end

    def content_for(entry, start_point = 10)
      move_down start_point
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