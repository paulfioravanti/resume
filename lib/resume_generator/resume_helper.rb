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
      formatted_name(d(RESUME[:name]))
    end

    def formatted_name(name)
      font('Times-Roman', size: 20) { text name }
    end

    def headline
      headline = RESUME[:headline]
      formatted_headline(
        d(headline[:ruby]),
        d(headline[:other])
      )
    end

    def formatted_headline(ruby, rest)
      formatted_text(
        [
          {
            text: ruby, color: '85200C'
          },
          {
            text: rest
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
        transparent_link(
          bars: resource.bars,
          size: resource.size,
          link: resource.link,
          align: resource.align
        )
      end
    end

    def transparent_link(options)
      transparent(0) do
        formatted_text(
          [
            {
              text: '|' * options[:bars],
              size: options[:size],
              link: options[:link]
            }
          ], align: options[:align]
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
      # jet
      # satc
    end

    # def education_history
    #   heading 'RWR1Y2F0aW9u'
    #   mit
    #   bib
    #   ryu
    #   tafe
    # end

    def rc
      header_text_for(:rc, 10)
      organisation_logo(:rc)
      content_for(:rc)
    end

    def fl
      header_text_for(:fl)
      organisation_logo(:fl, :ruby)
      organisation_logo(:fl, :rails, 33)
      content_for(:fl, 15)
    end

    def gw
      header_text_for(:gw)
      organisation_logo(:gw)
      content_for(:gw)
    end

    def rnt
      header_text_for(:rnt)
      organisation_logo(:rnt)
      content_for(:rnt)
    end

    def sra
      header_text_for(:sra)
      organisation_logo(:sra)
      content_for(:sra)
    end

    def header_text_for(position, start_point = 15)
      entry = RESUME[:entries][position]
      move_down start_point
      position(entry[:position])
      organisation(entry[:organisation])
      period_and_location(entry[:period], entry[:location])
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

    def position(string)
      formatted_text(
        formatted_position(d(string))
      )
    end

    def position_at(string, at)
      formatted_text_box(
        formatted_position(string),
        at: [at, cursor]
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

    def organisation(string)
      formatted_text(
        formatted_organisation(d(string))
      )
    end

    def organisation_at(string, at)
      formatted_text_box(
        formatted_organisation(string),
        at: [at, cursor]
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

    def period_and_location(period, location)
      formatted_text(
        [
          {
            text: d(period)
          },
          {
            text: d(location[:name]),
            link: d(location[:link])
          }
        ],
        color: '666666',
        size: 10
      )
    end

    def period_and_location_at(period, location, link, at)
      formatted_text_box(
        [
          {
            text: period, color: '666666', size: 10
          },
          {
            text: location,
            link: link,
            color: '666666', size: 10
          }
        ],
        at: [at, cursor]
      )
    end

    def organisation_logo(position, logo = position, start_point = 40)
      resource = Resource.for(RESUME[:entries][position][:logos][logo])
      move_up start_point
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image,
              fit: resource.fit,
              align: resource.align
        move_up resource.move_up
        transparent_link(
          bars: resource.bars,
          size: resource.size,
          link: resource.link,
          align: resource.align
        )
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

    # def sra
    #   move_down 15
    #   position_header(
    #     position: { title: 'U29mdHdhcmUgRW5naW5lZXI=' },
    #     organisation: { name: 'U29mdHdhcmUgUmVzZWFyY2ggQXNzb2NpYXRlcyAoU1JBKQ==' },
    #     period: 'QXByaWwgMjAwNiDigJMgSnVuZSAyMDA3IHwgIA==',
    #     location: 'VG9reW8sIEphcGFu',
    #     location_link: 'sra_location'
    #   )

    #   move_up 40
    #   organisation_logo(
    #     organisation: 'sra',
    #     origin: 415,
    #     width: 115,
    #     height: 40,
    #     fit: [110, 40],
    #     move_up: 40,
    #     bars: 10,
    #     size: 43
    #   )

    #   move_down 10
    #   text d "Q3VzdG9tIHNvZnR3YXJlIGRldmVsb3BtZW50IGluIHNtYWxsIHRlYW1zOyBkZX"\
    #          "NpZ24sIGNvZGluZywgdGVzdGluZywgZG9jdW1lbnRhdGlvbiwgZGVwbG95bWVu"\
    #          "dDsgaW50ZXJuYWwgc3lzdGVtIGFkbWluaXN0cmF0aW9uIGR1dGllcy4gIERldm"\
    #          "Vsb3BtZW50IHByZWRvbWluYW50bHkgZG9uZSB1c2luZyBQdXJlIFJ1YnkvUnVi"\
    #          "eSBvbiBSYWlscyBpbiBzbWFsbCB0ZWFtcyBvZiAyLTMgcGVvcGxlLg=="
    # end

    # def jet
    #   move_down 15
    #   position_header(
    #     position: { title: 'Q29vcmRpbmF0b3Igb2YgSW50ZXJuYXRpb25hbCBSZWxhdGlvbnMgKENJUik=' },
    #     organisation: { name: "SmFwYW4gRXhjaGFuZ2UgYW5kIFRlYWNoaW5nIFByb2dyYW1tZSAoSkVU"\
    #               "KQ==" },
    #     period: 'SnVseSAyMDAxIOKAkyBKdWx5IDIwMDQgfCAg',
    #     location: 'S29jaGksIEphcGFu',
    #     location_link: 'jet_location'
    #   )

    #   move_up 40
    #   organisation_logo(
    #     organisation: 'jet',
    #     origin: 435,
    #     width: 75,
    #     height: 35,
    #     fit: [110, 35],
    #     move_up: 34,
    #     bars: 8,
    #     size: 36
    #   )

    #   move_down 13
    #   text d "VHJhbnNsYXRpb24vaW50ZXJwcmV0aW5nOyBncmFzcy1yb290cyBjb21tdW5pdH"\
    #          "kgYWN0aXZpdGllcyBhbmQgam91cm5hbGlzbTsgcGxhbm5pbmcvaW1wbGVtZW50"\
    #          "aW5nIGludGVybmF0aW9uYWwgZXhjaGFuZ2UgcHJvamVjdHM7IGluYm91bmQgZ3"\
    #          "Vlc3QgaG9zcGl0YWxpdHk7IG91dGJvdW5kIHRvdXItZ3VpZGluZw=="
    # end

    # def satc
    #   move_down 15
    #   position_header(
    #     position: { title: "SW50ZXJuYXRpb25hbCBNYXJrZXRpbmcgQXNzaXN0YW50IOKAkyBBc2lhIGFu"\
    #                 "ZCBKYXBhbg==" },
    #     organisation: { name: 'U291dGggQXVzdHJhbGlhbiBUb3VyaXNtIENvbW1pc3Npb24=' },
    #     period: 'TWF5IDIwMDAg4oCTIE1heSAyMDAxIHwgIA==',
    #     location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
    #     location_link: 'satc_location'
    #   )

    #   move_up 40
    #   organisation_logo(
    #     organisation: 'satc',
    #     origin: 430,
    #     width: 90,
    #     height: 40,
    #     fit: [110, 40],
    #     move_up: 40,
    #     bars: 8,
    #     size: 43
    #   )

    #   move_down 10
    #   text d "QXNzaXN0IHdpdGggdGhlIHByb21vdGlvbi9tYXJrZXRpbmcgb2YgU291dGggQX"\
    #          "VzdHJhbGlhIGFzIGEgdG91cmlzbSBkZXN0aW5hdGlvbiB0byBBc2lhIGFuZCBK"\
    #          "YXBhbi4="

    #   move_down 10
    #   stroke_horizontal_rule { color '666666' }
    # end

    # def mit
    #   move_down 15
    #   position_header(
    #     position: { title: 'TWFzdGVycyBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5' },
    #     organisation: { name: 'VW5pdmVyc2l0eSBvZiBTb3V0aCBBdXN0cmFsaWE=' },
    #     period: 'MjAwNC0yMDA1IHw=',
    #     location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
    #     location_link: 'mit_location'
    #   )

    #   move_up 40
    #   organisation_logo(
    #     organisation: 'mit',
    #     origin: 210,
    #     width: 35,
    #     height: 40,
    #     fit: [35, 40],
    #     move_up: 35,
    #     bars: 3,
    #     size: 43
    #   )
    # end

    # def bib
    #   move_up 38
    #   position_header(
    #     position: { title: 'QmFjaGVsb3Igb2YgSW50ZXJuYXRpb25hbCBCdXNpbmVzcw==', at: 280 },
    #     organisation: { name: 'RmxpbmRlcnMgVW5pdmVyc2l0eQ==', at: 280 },
    #     period: 'MTk5Ny0xOTk5IHw=',
    #     location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
    #     location_link: 'bib_location',
    #     at: 280
    #   )

    #   move_up 30
    #   organisation_logo(
    #     organisation: 'bib',
    #     origin: 490,
    #     width: 35,
    #     height: 40,
    #     fit: [35, 40],
    #     move_up: 40,
    #     bars: 3,
    #     size: 43
    #   )
    # end

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
