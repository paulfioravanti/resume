module ResumeGenerator
  module ResumeEntryHelper
    def social_media_icons
      move_down 5
      resources = social_media_resources
      x_position = 0
      social_media_icon_for(resources.first, x_position)
      x_position += 45
      resources[1..-1].each do |resource|
        move_up 46.25
        social_media_icon_for(resource, x_position)
        x_position += 45
      end
      stroke_horizontal_rule { color '666666' }
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

    def employment_history
      heading d('RW1wbG95bWVudCBIaXN0b3J5')
      rc
      fl
      gw
      rnt
      sra
      jet
      satc
      move_down 10
      stroke_horizontal_rule { color '666666' }
    end

    def rc
      header_text_for(:rc, 10)
      organisation_logo_for(:rc)
      content_for(:rc)
    end

    def fl
      header_text_for(:fl)
      organisation_logo_for(:fl, :ruby)
      organisation_logo_for(:fl, :rails, 33)
      content_for(:fl, 15)
    end

    def gw
      header_text_for(:gw)
      organisation_logo_for(:gw)
      content_for(:gw)
    end

    def rnt
      header_text_for(:rnt)
      organisation_logo_for(:rnt)
      content_for(:rnt)
    end

    def sra
      header_text_for(:sra)
      organisation_logo_for(:sra)
      content_for(:sra)
    end

    def jet
      header_text_for(:jet)
      organisation_logo_for(:jet)
      content_for(:jet)
    end

    def satc
      header_text_for(:satc)
      organisation_logo_for(:satc)
      content_for(:satc)
    end

    def education_history
      heading d('RWR1Y2F0aW9u')
      mit
      bib
      ryu
      tafe
    end

    def mit
      header_text_for(:mit)
      organisation_logo_for(:mit)
    end

    def bib
      move_up 38
      header_text_for(:bib, 0)
      move_up 30
      organisation_logo_for(:bib, :bib, 0)
    end

    def ryu
      header_text_for(:ryu, 20)
      organisation_logo_for(:ryu)
    end

    def tafe
      move_up 38
      header_text_for(:tafe, 0)
      move_up 23
      organisation_logo_for(:tafe, :tafe, 0)
    end

    def organisation_logo_for(position, logo = position, start_point = 40)
      resource = logo_resource(position, logo)
      move_up start_point
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image, fit: resource.fit, align: resource.align
        move_up resource.move_up
        transparent_link(resource)
      end
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