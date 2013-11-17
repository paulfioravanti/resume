module ResumeGenerator
  module ResumeEntryHelper
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

    def rc(entry)
      header_text_for(entry, 10)
      organisation_logo_for(entry, :rc)
      content_for(entry)
    end

    def fl(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :ruby)
      organisation_logo_for(entry, :rails, 33)
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

    def header_text_for(entry, y_start = 15)
      # entry = RESUME[:entries][position]
      move_down y_start
      return formatted_text_boxes_for(entry) if entry[:at]
      formatted_text_fields_for(entry)
    end

    def organisation_logo_for(entry, logo, start_point = 40)
      organisation_logo = entry[:logos][logo]
      resource = logo_resource(entry, organisation_logo)
      move_up start_point
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image, fit: resource.fit, align: resource.align
        move_up resource.move_up
        transparent_link(resource)
      end
    end

    def logo_resource(entry, logo)
      logo.merge!(at: entry[:at])
      Resource.for(logo)
    end

    def content_for(entry, start_point = 10)
      move_down start_point
      summary(entry[:summary])
      profile(entry[:profile])
    end

    def mit(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :mit)
    end

    def bib(entry)
      move_up 38
      header_text_for(entry, 0)
      move_up 30
      organisation_logo_for(entry, :bib, 0)
    end

    def ryu(entry)
      header_text_for(entry, 20)
      organisation_logo_for(entry, :ryu)
    end

    def tafe(entry)
      move_up 38
      header_text_for(entry, 0)
      move_up 23
      organisation_logo_for(entry, :tafe, 0)
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

    def position(entry)
      formatted_text(
        formatted_position(d(entry[:position]))
      )
    end

    def position_at(entry)
      formatted_text_box(
        formatted_position(d(entry[:position])),
        at: [entry[:at], cursor]
      )
      move_down 14
    end

    def formatted_position(string)
      [
        {
          text: string,
          styles: [:bold]
        }
      ]
    end

    def organisation(entry)
      formatted_text(
        formatted_organisation(d(entry[:organisation]))
      )
    end

    def organisation_at(entry)
      formatted_text_box(
        formatted_organisation(d(entry[:organisation])),
        at: [entry[:at], cursor]
      )
      move_down 13
    end

    def formatted_organisation(string)
      [
        {
          text: string,
          styles: [:bold],
          size: 11
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

    def summary(string)
      text d(string)
    end

    def profile(items)
      return unless items
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [] })
    end
  end
end