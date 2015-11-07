require_relative '../../decoder'
require_relative '../transparent_link'
require_relative 'header'
require_relative 'company_logo'

module Resume
  module PDF
    module Entry
      class Content
        include TransparentLink

        def self.generate(pdf, entry)
          new(pdf, entry).generate
        end

        private_class_method :new

        def initialize(pdf, entry)
          @pdf = pdf
          @entry = entry
        end

        def generate
          pdf.move_down entry[:top_padding]
          Header.generate(pdf, entry)
          CompanyLogo.generate(pdf, entry)
          details if entry.has_key?(:summary)
        end

        private

        attr_reader :pdf, :entry

        def details
          pdf.move_down entry[:summary][:top_padding]
          summary
          profile
        end

        def summary
          pdf.text(
            entry[:summary][:text],
            inline_format: true
          )
        end

        def profile
          items = entry[:profile]
          cell_style = entry[:cell_style]
          return unless items
          table_data = items.reduce([]) do |data, item|
            data << ['-', item]
          end
          pdf.table(
            table_data,
            cell_style: {
              borders: cell_style[:borders],
              height: cell_style[:height]
            }
          )
        end
      end
    end
  end
end
