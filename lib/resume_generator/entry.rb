require 'logo_link'
require 'header'

module ResumeGenerator
  class Entry
    include Decoder, Utilities

    attr_reader :pdf, :entry

    def self.generate(pdf, entry)
      new(pdf, entry).generate
    end

    def initialize(pdf, entry)
      @pdf = pdf
      @entry = entry
    end

    def generate
      pdf.move_down entry[:top_padding]
      Header.generate(pdf, entry)
      LogoLink.generate(pdf, entry)
      details if entry.has_key?(:summary)
    end

    private

    def details
      pdf.move_down entry[:summary][:top_padding]
      summary
      profile
    end

    def summary
      pdf.text(d(entry[:summary][:text]), inline_format: true)
    end

    def profile
      return unless items = entry[:profile]
      table_data = items.reduce([]) do |data, item|
        data << ['-', d(item)]
      end
      pdf.table(
        table_data,
        cell_style: {
          borders: entry[:cell_style][:borders],
          height: entry[:cell_style][:height]
        }
      )
    end
  end
end
