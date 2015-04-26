require 'logo_link'
require 'header'

module ResumeGenerator
  class Listing
    include Decoder, Utilities

    attr_reader :pdf, :data

    def self.generate(pdf, data)
      new(pdf, data).generate
    end

    def initialize(pdf, data)
      @pdf = pdf
      @data = data
    end

    def generate
      pdf.move_down data[:top_padding]
      Header.generate(pdf, data)
      LogoLink.generate(pdf, data)
      details if data.has_key?(:summary)
    end

    private

    def details
      pdf.move_down data[:summary_top_padding]
      summary(data[:summary])
      profile(data[:profile])
    end

    def summary(string)
      pdf.text(d(string), inline_format: true)
    end

    def profile(items)
      return unless items
      table_data = items.reduce([]) do |data, item|
        data << ['-', d(item)]
      end
      pdf.table(
        table_data,
        cell_style: {
          borders: data[:table_cell_borders],
          height: data[:table_cell_height]
        }
      )
    end
  end
end
