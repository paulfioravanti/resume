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
      RESUME[:social_media].reduce([]) do |resources, social_medium|
        resources << Resource.for(social_medium)
      end
    end

    def social_media_icon_for(resource, x_position)
      bounding_box([x_position, cursor], width: 35) do
        image resource.image, fit: [35, 35], align: :center
        move_up 35
        transparent_link(
          bars: 3,
          size: 40,
          link: resource.link,
          align: :center
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
      # heading d('RW1wbG95bWVudCBIaXN0b3J5')
      # rc
      # fl
      # gw
      # rnt
      # sra
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

    # Next attempted refactor: Shove all info about the positions into
    # a JSON feed on Github that will be read in and populate the resume

    # def rc
    #   move_down 10
    #   position(Position.for(:rc))
    #   organisation(Organisation.for(:rc))
    #   period_and_location(Period.for(:rc),
    #     Location.for(:rc), Link.for(:rc_location))

    #   move_up 40
    #   organisation_logo(Logo.for(:rc))

    #   move_down 10
    #   summary(
    #     "UnVieSBvbiBSYWlscyBkZXZlbG9wZXIgZm9yIFJhdGVDaXR5LmNvbS5hdSBmaW"\
    #     "5hbmNpYWwgcHJvZHVjdHMgYW5kIHNlcnZpY2VzIGNvbXBhcmlzb24gd2Vic2l0"\
    #     "ZS4="
    #   )
    #   profile(
    #     "T3VyIHRlYW0gaXMgZmllcmNlbHkgQWdpbGUsIHdpdGggdGlnaHQgZGV2ZWxvcG1lbnQ"\
    #       "gZmVlZGJhY2sgbG9vcHMgb2Ygb25lIHdlZWssIG1lYXN1cmVkIGFuZCBtYW5hZ2Vk"\
    #       "IHRyYW5zcGFyZW50bHkgaW4gVHJlbGxvIGFuZCBkYWlseSBzdGFuZC11cCBtZWV0a"\
    #       "W5ncw==",
    #     "V2UgYWN0aXZlbHkgdXNlIFJTcGVjIGZvciB0ZXN0LWRyaXZlbiBkZXZlbG9wbWVudCw"\
    #       "gYW5kIG1lYXN1cmUgb3VyIGNvZGUgcXVhbGl0eSB1c2luZyBzZXJ2aWNlcyBsaWtl"\
    #       "IENvZGUgQ2xpbWF0ZSBhbmQgQ292ZXJhbGxz",
    #     "R2l0aHViIHB1bGwgcmVxdWVzdHMsIGNvbnRpbnVvdXMgaW50ZWdyYXRpb24gd2l0aCB"\
    #       "UcmF2aXMgUHJvLCBwZWVyIGNvZGUgcmV2aWV3LCBhbmQgY29udGludW91cyBzdGFn"\
    #       "aW5nL3Byb2R1Y3Rpb24gZGVwbG95cyBhcmUgY2VudHJhbCB0byBvdXIgZXZlcnlkY"\
    #       "XkgZGV2ZWxvcG1lbnQgd29ya2Zsb3c=",
    #     "V2UgZ2V0IHN0dWZmIGRvbmUsIGdldCBpdCBsaXZlIGZhc3QsIGFuZCBzdHJpdmUgdG8"\
    #       "gZ2V0IGJldHRlcg=="
    #   )
    # end

    # def fl
    #   move_down 15

    #   position(Position.for(:fl))
    #   organisation(Organisation.for(:fl))
    #   period_and_location(Period.for(:fl),
    #     Location.for(:fl), Link.for(:fl_location))

    #   move_up 40
    #   organisation_logo(Logo.for(:ruby))
    #   move_up 33
    #   organisation_logo(Logo.for(:rails))

    #   move_down 15
    #   summary(
    #     "UGFydC10aW1lIGFuZCBwcm9qZWN0LWJhc2VkIFJ1Ynkgb24gUmFpbHMgd29yay"\
    #       "Bmb3IgbG9jYWwgc3RhcnQtdXAgYW5kIHNtYWxsIGNvbXBhbmllcy4="
    #   )
    # end

    # def gw
    #   move_down 15
    #   gw = GW.new

    #   position(gw.position)
    #   organisation(gw.organisation)
    #   period_and_location(gw.period, gw.location, gw.location_link)

    #   move_up 40
    #   organisation_logo(gw.logo)

    #   move_down 10
    #   summary(
    #     "Q29tcGxleCBzYWxlcyBvZiBHdWlkZXdpcmUgQ2xhaW1DZW50ZXIgaW5zdXJhbm"\
    #       "NlIGNsYWltIGhhbmRsaW5nIHN5c3RlbSB0byBidXNpbmVzcyBhbmQgSVQgZGVw"\
    #       "YXJ0bWVudHMgb2YgUHJvcGVydHkgJiBDYXN1YWx0eSBpbnN1cmFuY2UgY29tcG"\
    #       "FuaWVzLg=="
    #   )
    #   profile(
    #     "UGVyZm9ybSB2YWx1ZS1iYXNlZCBhbmQgdGVjaG5vbG9neS1mb2N1c2VkIHByZXNlbnR"\
    #       "hdGlvbnMgYW5kIHByb2R1Y3QgZGVtb25zdHJhdGlvbnM=",
    #     "Q29uZHVjdCBBZ2lsZS1kcml2ZW4gUHJvb2Ygb2YgQ29uY2VwdCB3b3Jrc2hvcHMgZm9"\
    #       "yIHByb3NwZWN0cw==",
    #     "V29yayB3aXRoIFN5c3RlbSBJbnRlZ3JhdG9yIHBhcnRuZXIgY29tcGFuaWVzIGluIHR"\
    #       "oZWlyIEd1aWRld2lyZSBwcm9qZWN0IHByb3Bvc2Fscw==",
    #     "Q29uZHVjdCBidXNpbmVzcyBwcm9jZXNzIGFuZCBwcm9kdWN0IHZhbHVlIGNvbnN1bHR"\
    #       "pbmcgd29ya3Nob3BzIGZvciBwcm9zcGVjdHMvY3VzdG9tZXJz",
    #     'UHJlcGFyZSB3cml0dGVuIHJlc3BvbnNlcyB0byBjdXN0b21lciBSRlAvUkZJcw==',
    #     "RGVtbyBlbnZpcm9ubWVudCBjb25maWd1cmF0aW9uIGFuZCBwcm9zcGVjdCByZXF1aXJ"\
    #       "lbWVudC1kcml2ZW4gZnVuY3Rpb24gZGV2ZWxvcG1lbnQ=",
    #     "UHJvZHVjdCBsb2NhbGl6YXRpb24gZGV2ZWxvcG1lbnQgZm9yIEphcGFuZXNlIG1hcmt"\
    #       "ldA==",
    #     'Q3VzdG9tZXIgcHJvZHVjdCB0cmFpbmluZw==',
    #     'SmFwYW4gYW5kIG92ZXJzZWFzIHRyYWRlIHNob3dzL21hcmtldGluZyBldmVudHM='
    #   )
    # end

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
        formatted_position(string)
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
        formatted_organisation(string)
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

    def period_and_location(period, location, link)
      formatted_text(
        [
          {
            text: period
          },
          {
            text: location,
            link: link
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

    def organisation_logo(logo)
      bounding_box([logo[:origin], cursor],
                   width: logo[:width],
                   height: logo[:height]) do
        image logo[:resource].image,
              fit: logo[:fit],
              align: :center
        move_up logo[:move_up]
        transparent_link(
          bars: logo[:bars],
          size: logo[:size],
          link: logo[:resource].link,
          align: :left
        )
      end
    end

    def summary(string)
      text d(string)
    end

    def profile(*items)
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [] })
    end

    # def rnt
    #   move_down 15
    #   position_header(
    #     position: { title: "SW1wbGVtZW50YXRpb24gQ29uc3VsdGFudCwgUHJvZmVzc2lvbmFsIFNlcn"\
    #                 "ZpY2Vz" },
    #     organisation: { name: 'UmlnaHQgTm93IFRlY2hub2xvZ2llcw==' },
    #     period: 'SnVseSAyMDA3IOKAkyBBdWd1c3QgMjAwOCB8ICA=',
    #     location: 'VG9reW8sIEphcGFu',
    #     location_link: 'rnt_location'
    #   )

    #   move_up 40
    #   organisation_logo(
    #     organisation: 'rnt',
    #     origin: 435,
    #     width: 80,
    #     height: 40,
    #     fit: [110, 40],
    #     move_up: 40,
    #     bars: 7,
    #     size: 43
    #   )

    #   move_down 10
    #   text d "T24gYW5kIG9mZi1zaXRlIGN1c3RvbWVyIGltcGxlbWVudGF0aW9ucyBvZiBSaW"\
    #          "dodCBOb3cgQ2xvdWQgQ1JNIHByb2R1Y3Qu"

    #   bullet_list(
    #     "Q29uZmlybSBoaWdoLWxldmVsIGJ1c2luZXNzIHJlcXVpcmVtZW50cyBmZWFzaWJpbGl"\
    #       "0eSB3aXRoIHByZS1zYWxlcyB0ZWFt",
    #     "RG9jdW1lbnRhdGlvbjogcHJvamVjdCBjaGFydGVyLCBzY29wZSwgc2NoZWR1bGVzLCB"\
    #       "hbmQgdGVjaG5pY2FsIGRlc2lnbiBvZiBjdXN0b21pemF0aW9ucw==",
    #     "Q29uZHVjdCBpbmNlcHRpb24gcGhhc2UgcmVxdWlyZW1lbnRzIHdvcmtzaG9wcyBmb3I"\
    #       "gYnVzaW5lc3MgcHJvY2Vzc2VzLCB3b3JrZmxvd3MsIGFuZCBwcm9kdWN0IGltcGxl"\
    #       "bWVudGF0aW9uOyBkZXRlcm1pbmUgcG9zc2libGUgb3V0LW9mLXNjb3BlIGNoYW5nZ"\
    #       "SByZXF1ZXN0cyBhcyBuZWVkZWQ=",
    #     "Q29uZmlndXJlIGFuZCBzZXR1cCBwcm9kdWN0IHRlc3QgZW52aXJvbm1lbnQgZm9yIGN"\
    #       "saWVudCB0byB0cmFjayBwcm9qZWN0IHByb2dyZXNz",
    #     "TWFuYWdlLCBRQSwgYW5kIGxvY2FsaXplIGN1c3RvbWl6YXRpb24gd29yayBwZXJmb3J"\
    #       "tZWQgYnkgZW5naW5lZXJz",
    #     'RG9jdW1lbnQgYW5kIGV4ZWN1dGUgb24tc2l0ZSBVQVQgYW5kIHRyYWluaW5n',
    #     "UHJlcGFyZSBhbmQgZXhlY3V0ZSDigJxzaXRlIGdvLWxpdmXigJ0sIGFuYWx5emUgcml"\
    #       "za3MsIHByZXBhcmUgZmFsbGJhY2sgcGxhbnM=",
    #     "V29yayB3aXRoIGN1c3RvbWVyIHN1cHBvcnQgdG8gaGFuZGxlIGltcGxlbWVudGF0aW9"\
    #       "uLXJlbGF0ZWQgc3VwcG9ydCBpbmNpZGVudHM=",
    #     "SG9zdCwgbGluZ3Vpc3RpY2FsbHkgc3VwcG9ydCwgYW5kIGhhbmRsZSBKYXBhbiBpbW1"\
    #       "pZ3JhdGlvbiBvZiBvdmVyc2VhcyBwcm9qZWN0IG1lbWJlcnM="
    #   )
    # end

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
