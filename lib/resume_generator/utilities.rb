module ResumeGenerator
  module Utilities

    private

    def header_text_for(entry, y_start = 15)
      move_down y_start
      return formatted_text_boxes_for(entry) if entry[:at]
      formatted_text_fields_for(entry)
    end

    def formatted_text_fields_for(entry)
      position(entry)
      organisation(entry)
      period_and_location(entry)
    end

    def formatted_text_boxes_for(entry)
      position_at(entry)
      organisation_at(entry)
      period_and_location_at(entry)
    end

    def transparent_link(resource)
      transparent(0) do
        formatted_text(
          [
            {
              text: '|' * resource.bars,
              size: resource.size,
              link: resource.link
            }
          ], align: resource.align
        )
      end
    end

    def heading(string)
      move_down 10
      formatted_text(
        [
          {
            text: string,
            styles: [:bold],
            color: '666666'
          }
        ]
      )
    end

    def position(entry)
      formatted_text(
        formatted_entry(d(entry[:position]), 12)
      )
    end

    def position_at(entry)
      formatted_text_box(
        formatted_entry(d(entry[:position]), 12),
        at: [entry[:at], cursor]
      )
      move_down 14
    end

    def organisation(entry)
      formatted_text(
        formatted_entry(d(entry[:organisation]), 11)
      )
    end

    def organisation_at(entry)
      formatted_text_box(
        formatted_entry(d(entry[:organisation]), 11),
        at: [entry[:at], cursor]
      )
      move_down 13
    end

    def formatted_entry(string, size)
      [
        {
          text: string,
          styles: [:bold],
          size: size
        }
      ]
    end

    def period_and_location(entry)
      formatted_text(
        [
          {
            text: d(entry[:period])
          },
          {
            text: d(entry[:location][:name]),
            link: d(entry[:location][:link])
          }
        ],
        color: '666666',
        size: 10
      )
    end

    def period_and_location_at(entry)
      formatted_text_box(
        [
          {
            text: d(entry[:period]), color: '666666', size: 10
          },
          {
            text: d(entry[:location][:name]),
            link: d(entry[:location][:link]),
            color: '666666', size: 10
          }
        ],
        at: [entry[:at], cursor]
      )
    end
  end
end