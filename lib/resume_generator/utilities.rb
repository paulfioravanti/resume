module ResumeGenerator
  module Utilities
    private

    def resources_for(social_media)
      social_media[:resources].values.map do |social_medium|
        social_medium.merge!(social_media[:properties])
        Resource.for(social_medium)
      end
    end

    def social_media_icon_for(resource, x_position)
      bounding_box([x_position, cursor], width: resource.width) do
        image(
          resource.image,
          fit: resource.fit,
          align: resource.align
        )
        move_up 35
        transparent_link(resource)
      end
    end

    def listing_for(entry)
      header_for(entry)
      logo_link_for(entry)
      details_for(entry) if entry.has_key?(:summary)
    end

    def header_for(entry)
      move_down entry[:y_header_start] || 15
      if entry[:at]
        formatted_text_boxes_for(entry)
      else
        formatted_text_fields_for(entry)
      end
    end

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

    def formatted_text_fields_for(entry)
      position(entry)
      organisation(entry)
      period_and_location(entry)
    end

    def formatted_text_boxes_for(entry)
      formatted_entry_for(entry[:position], 12, entry[:at], 14)
      formatted_entry_for(entry[:organisation], 11, entry[:at], 13)
      period_and_location_at(entry)
    end

    def logo_link_for(entry)
      resource = logo_resource(entry)
      move_up entry[:y_logo_start] || 40
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image, fit: resource.fit, align: resource.align
        move_up resource.move_up
        transparent_link(resource)
      end
    end

    def logo_resource(entry)
      logo = entry[:logo].merge(at: entry[:at])
      Resource.for(logo)
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

    def organisation(entry)
      formatted_text(
        formatted_entry(d(entry[:organisation]), 11)
      )
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

    def formatted_entry_for(item, size, at, reset_point)
      formatted_text_box(
        formatted_entry(d(item), size),
        at: [at, cursor]
      )
      move_down reset_point
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