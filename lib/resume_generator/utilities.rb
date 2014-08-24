module ResumeGenerator
  # Bag O' Methods Module
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
        image(resource.image, fit: resource.fit, align: resource.align)
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
      table_data = items.reduce([]) do |data, item|
        data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [], height: 21 })
    end

    def formatted_text_fields_for(entry)
      formatted_entry(d(entry[:position]), 12)
      formatted_entry(d(entry[:organisation]), 11)
      period_and_location(
        d(entry[:period]),
        d(entry[:location][:name]),
        d(entry[:location][:link])
      )
    end

    def formatted_text_boxes_for(entry)
      formatted_entry_for(d(entry[:position]), 12, entry[:at], 14)
      formatted_entry_for(d(entry[:organisation]), 11, entry[:at], 13)
      period_and_location_at(
        d(entry[:period]),
        d(entry[:location][:name]),
        d(entry[:location][:link]),
        [entry[:at], cursor]
      )
    end

    def logo_link_for(entry)
      logo = Resource.for(entry[:logo].merge(at: entry[:at]))
      move_up entry[:y_logo_start] || 40
      bounding_box([logo.origin, cursor],
        width: logo.width, height: logo.height) do
        image logo.image, fit: logo.fit, align: logo.align
        move_up logo.move_up
        transparent_link(logo)
      end
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

    def formatted_entry(item, size)
      formatted_text(
        *formatted_entry_args_for(item, size),
      )
    end

    def formatted_entry_for(item, size, at, reset_point)
      formatted_text_box(
        *formatted_entry_args_for(item, size, [at, cursor])
      )
      move_down reset_point
    end

    def period_and_location(period, location, link)
      formatted_text(
        *period_and_location_args_for(period, location, link)
      )
    end

    def period_and_location_at(period, location, link, at)
      formatted_text_box(
        *period_and_location_args_for(period, location, link, at)
      )
    end

    def formatted_entry_args_for(string, size, at = nil)
      [
        [
          {
            text: string,
            styles: [:bold],
            size: size
          }
        ],
        at: at
      ]
    end

    def period_and_location_args_for(period, name, link, at = nil)
      [
        [
          {
            text: period, color: '666666', size: 10
          },
          {
            text: name,
            link: link,
            color: '666666', size: 10
          }
        ],
        at: at
      ]
    end
  end
end