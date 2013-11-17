require 'json'

module ResumeGenerator
  module ResumeHelper
    RESUME =
      JSON.parse(
        open('resources/resume.json').read,
        symbolize_names: true
      )[:resume]

    def self.included(base)
      Resume.extend(ClassMethods)
    end

    module ClassMethods
      def background_image
        open(RESUME[:background_image])
      end
    end

    private

    def name
      font('Times-Roman', size: 20) { text d(RESUME[:name]) }
    end

    def headline
      headline = RESUME[:headline]
      formatted_text(
        [
          {
            text: d(headline[:ruby]), color: '85200C'
          },
          {
            text: d(headline[:other])
          }
        ],
        size: 14
      )
    end

    def social_media_links
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

    def social_media_resources
      properties = RESUME[:social_media][:properties]
      RESUME[:social_media][:resources].values.map do |social_medium|
        social_medium.merge!(properties)
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

    def education_history
      heading d('RWR1Y2F0aW9u')
      mit
      bib
    #   ryu
    #   tafe
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

    def header_text_for(position, start_point = 15)
      entry = RESUME[:entries][position]
      move_down start_point
      if entry[:at]
        position_at(entry)
        organisation_at(entry)
        period_and_location_at(entry)
      else
        position(entry)
        organisation(entry)
        period_and_location(entry)
      end
    end

    def content_for(position, start_point = 10)
      entry = RESUME[:entries][position]
      move_down start_point
      summary(entry[:summary])
      profile(entry[:profile]) if entry[:profile]
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

    def organisation_logo_for(position, logo = position, start_point = 40)
      entry = RESUME[:entries][position]
      position_logo = entry[:logos][logo]
      position_logo.merge!(at: entry[:at]) if entry[:at]
      resource = Resource.for(position_logo)
      move_up start_point
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image, fit: resource.fit, align: resource.align
        move_up resource.move_up
        transparent_link(resource)
      end
    end

    def summary(string)
      text d(string)
    end

    def profile(items)
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [] })
    end

    # def ryu
    #   move_down 20
    #   position_header(
    #     position: { title: 'U3R1ZGVudCBFeGNoYW5nZSBQcm9ncmFtbWU=' },
    #     organisation: { name: 'Unl1a29rdSBVbml2ZXJzaXR5' },
    #     period: 'U2VwIDE5OTkgLSBGZWIgMjAwMCB8',
    #     location: 'S3lvdG8sIEphcGFu',
    #     location_link: 'ryu_location'
    #   )

    #   move_up 40
    #   organisation_logo(
    #     organisation: 'ryu',
    #     origin: 214,
    #     width: 32,
    #     height: 40,
    #     fit: [32, 40],
    #     move_up: 40,
    #     bars: 3,
    #     size: 40
    #   )
    # end

    # def tafe
    #   move_up 38
    #   position_header(
    #     position: { title: 'Q2VydGlmaWNhdGUgSUkgaW4gVG91cmlzbQ==', at: 280 },
    #     organisation: { name: 'QWRlbGFpZGUgVEFGRQ==', at: 280 },
    #     period: 'TWF5IDIwMDAgLSBNYXkgMjAwMSB8',
    #     location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
    #     location_link: 'tafe_location',
    #     at: 280
    #   )

    #   move_up 23
    #   organisation_logo(
    #     organisation: 'tafe',
    #     origin: 490,
    #     width: 37,
    #     height: 35,
    #     fit: [37, 35],
    #     move_up: 19,
    #     bars: 5,
    #     size: 28
    #   )
    # end
  end
end
