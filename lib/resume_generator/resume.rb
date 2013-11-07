require 'resume_helper'
require 'decodable'

module ResumeGenerator
  class Resume
    def self.generate
      Prawn::Document.class_eval do
        include ResumeHelper, Decodable
      end
      Prawn::Document.generate("#{DOCUMENT_NAME}.pdf",
        margin_top: 0.75, margin_bottom: 0.75, margin_left: 1, margin_right: 1,
        background: Image.for('background'),
        repeat: true) do

        CLI.report "Generating PDF. "\
                   "This shouldn't take longer than a few seconds..."

        name 'UGF1bCBGaW9yYXZhbnRp'
        description 'UnVieSBEZXZlbG9wZXIg',
                    "YW5kIEluZm9ybWF0aW9uIFRlY2hub2xvZ3kgU2VydmljZXMgUHJvZmVzc"\
                    "2lvbmFs"

        ########################################################################
        ### Social Media
        ########################################################################
        CLI.report 'Creating social media links section...'
        move_down 5
        social_media_links
        stroke_horizontal_rule { color '666666' }

        CLI.report 'Creating employment history section...'
        move_down 10
        heading 'RW1wbG95bWVudCBIaXN0b3J5'
        ########################################################################
        ### RC
        ########################################################################
        move_down 10
        position 'U2VuaW9yIERldmVsb3Blcg=='
        organisation 'UmF0ZUNpdHkuY29tLmF1'
        period_and_location(
          period: 'SnVseSAyMDEzIC0gUHJlc2VudCB8',
          location: 'U3lkbmV5LCBBdXN0cmFsaWE=',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9xPTYxK0xhdmVuZGVyK"\
                "1N0K01pbHNvbnMrUG9pbnQrTlNXKzIwNjEmaGw9ZW4mbGw9LTMzLjg1MDYwMi"\
                "wxNTEuMjEzMTYmc3BuPTAuMDI3MjY1LDAuMDM4OTY3JnNsbD0tMzMuODQzNjU"\
                "5LDE1MS4yMDk5NDkmc3Nwbj0wLjAwNjgxNywwLjAwOTc0MiZobmVhcj02MStM"\
                "YXZlbmRlcitTdCwrTWlsc29ucytQb2ludCtOZXcrU291dGgrV2FsZXMrMjA2M"\
                "SZ0PW0mej0xNQ=="
        )
        move_up 40
        organisation_logo(
          organisation: 'rc',
          origin: 415,
          width: 115,
          height: 40,
          fit: [110, 40],
          move_up: 40,
          bars: 10,
          size: 43
        )

        move_down 10
        text d "UnVieSBvbiBSYWlscyBkZXZlbG9wZXIgZm9yIFJhdGVDaXR5LmNvbS5hdSBmaW"\
               "5hbmNpYWwgcHJvZHVjdHMgYW5kIHNlcnZpY2VzIGNvbXBhcmlzb24gd2Vic2l0"\
               "ZS4="

        bullet_list(
          "T3VyIHRlYW0gaXMgZmllcmNlbHkgQWdpbGUsIHdpdGggdGlnaHQgZGV2ZWxvcG1lbnQ"\
            "gZmVlZGJhY2sgbG9vcHMgb2Ygb25lIHdlZWssIG1lYXN1cmVkIGFuZCBtYW5hZ2Vk"\
            "IHRyYW5zcGFyZW50bHkgaW4gVHJlbGxvIGFuZCBkYWlseSBzdGFuZC11cCBtZWV0a"\
            "W5ncw==",
          "V2UgYWN0aXZlbHkgdXNlIFJTcGVjIGZvciB0ZXN0LWRyaXZlbiBkZXZlbG9wbWVudCw"\
            "gYW5kIG1lYXN1cmUgb3VyIGNvZGUgcXVhbGl0eSB1c2luZyBzZXJ2aWNlcyBsaWtl"\
            "IENvZGUgQ2xpbWF0ZSBhbmQgQ292ZXJhbGxz",
          "R2l0aHViIHB1bGwgcmVxdWVzdHMsIGNvbnRpbnVvdXMgaW50ZWdyYXRpb24gd2l0aCB"\
            "UcmF2aXMgUHJvLCBwZWVyIGNvZGUgcmV2aWV3LCBhbmQgY29udGludW91cyBzdGFn"\
            "aW5nL3Byb2R1Y3Rpb24gZGVwbG95cyBhcmUgY2VudHJhbCB0byBvdXIgZXZlcnlkY"\
            "XkgZGV2ZWxvcG1lbnQgd29ya2Zsb3c=",
          "V2UgZ2V0IHN0dWZmIGRvbmUsIGdldCBpdCBsaXZlIGZhc3QsIGFuZCBzdHJpdmUgdG8"\
            "gZ2V0IGJldHRlcg=="
        )
        ########################################################################
        ### FL
        ########################################################################
        move_down 15
        position 'UnVieSBEZXZlbG9wZXI='
        organisation 'RnJlZWxhbmNl'
        period_and_location(
          period: 'U2VwdGVtYmVyIDIwMTIg4oCTIEp1bHkgMjAxMyB8ICA=',
          location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc291cmNlPXNfcSZob"\
                "D1lbiZnZW9jb2RlPSZxPWFkZWxhaWRlLCthdXN0cmFsaWEmYXE9JnNsbD0tMz"\
                "QuOTYxNjkyLDEzOC42MjEzOTkmc3Nwbj0wLjA1NjgzNiwwLjA3MTU4MyZ2cHN"\
                "yYz00JmllPVVURjgmaHE9JmhuZWFyPUFkZWxhaWRlK1NvdXRoK0F1c3RyYWxp"\
                "YSwrQXVzdHJhbGlhJnQ9bSZ6PTkmaXdsb2M9QQ=="
        )

        move_up 40
        organisation_logo(
          organisation: 'ruby',
          origin: 440,
          width: 37,
          height: 33,
          fit: [31, 31],
          move_up: 30,
          bars: 4,
          size: 34
        )

        move_up 33
        organisation_logo(
          organisation: 'rails',
          origin: 480,
          width: 32,
          height: 34,
          fit: [31, 31],
          move_up: 30,
          bars: 3,
          size: 35
        )

        move_down 15
        text d "UGFydC10aW1lIGFuZCBwcm9qZWN0LWJhc2VkIFJ1Ynkgb24gUmFpbHMgd29yay"\
               "Bmb3IgbG9jYWwgc3RhcnQtdXAgYW5kIHNtYWxsIGNvbXBhbmllcy4="
        ########################################################################
        ### GW
        ########################################################################
        move_down 15
        position 'UHJlLXNhbGVzIENvbnN1bHRhbnQ='
        organisation 'R3VpZGV3aXJlIFNvZnR3YXJl'
        period_and_location(
          period: 'SmFudWFyeSAyMDA5IOKAkyBTZXB0ZW1iZXIgMjAxMSB8ICA=',
          location: 'VG9reW8sIEphcGFu',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc291cmNlPXNfcSZob"\
                "D1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjEwMC0wMDA2KyslRTYlOUQlQjElRT"\
                "QlQkElQUMlRTklODMlQkQlRTUlOEQlODMlRTQlQkIlQTMlRTclOTQlQjAlRTU"\
                "lOEMlQkElRTYlOUMlODklRTYlQTUlQkQlRTclOTQlQkEyLTctMSsrJUU2JTlD"\
                "JTg5JUU2JUE1JUJEJUU3JTk0JUJBJUUzJTgyJUE0JUUzJTgzJTg4JUUzJTgyJ"\
                "UI3JUUzJTgyJUEyKzEyJUU5JTlBJThFJmFxPSZzbGw9LTM0LjkyODYyMSwxMz"\
                "guNTk5OTU5JnNzcG49MS44MTk0MzYsMi4yOTA2NDkmdnBzcmM9MCZnPWFkZWx"\
                "haWRlLCthdXN0cmFsaWEmaWU9VVRGOCZocT0lRTMlODAlOTIxMDAtMDAwNisr"\
                "JUU2JTlEJUIxJUU0JUJBJUFDJUU5JTgzJUJEJUU1JThEJTgzJUU0JUJCJUEzJ"\
                "UU3JTk0JUIwJUU1JThDJUJBJUU2JTlDJTg5JUU2JUE1JUJEJUU3JTk0JUJBMi"\
                "03LTErKyVFNiU5QyU4OSVFNiVBNSVCRCVFNyU5NCVCQSVFMyU4MiVBNCVFMyU"\
                "4MyU4OCVFMyU4MiVCNyVFMyU4MiVBMisxMiVFOSU5QSU4RSZ0PW0mej0xNSZp"\
                "d2xvYz1BJmNpZD0xNzQ4MjYwNDQzMTMwNjkxMzEzMw=="
        )
        move_up 40
        organisation_logo(
          organisation: 'gw',
          origin: 415,
          width: 118,
          height: 39,
          fit: [110, 40],
          move_up: 32,
          bars: 11,
          size: 41
        )

        move_down 10
        text d "Q29tcGxleCBzYWxlcyBvZiBHdWlkZXdpcmUgQ2xhaW1DZW50ZXIgaW5zdXJhbm"\
               "NlIGNsYWltIGhhbmRsaW5nIHN5c3RlbSB0byBidXNpbmVzcyBhbmQgSVQgZGVw"\
               "YXJ0bWVudHMgb2YgUHJvcGVydHkgJiBDYXN1YWx0eSBpbnN1cmFuY2UgY29tcG"\
               "FuaWVzLg=="

        bullet_list(
          "UGVyZm9ybSB2YWx1ZS1iYXNlZCBhbmQgdGVjaG5vbG9neS1mb2N1c2VkIHByZXNlbnR"\
            "hdGlvbnMgYW5kIHByb2R1Y3QgZGVtb25zdHJhdGlvbnM=",
          "Q29uZHVjdCBBZ2lsZS1kcml2ZW4gUHJvb2Ygb2YgQ29uY2VwdCB3b3Jrc2hvcHMgZm9"\
            "yIHByb3NwZWN0cw==",
          "V29yayB3aXRoIFN5c3RlbSBJbnRlZ3JhdG9yIHBhcnRuZXIgY29tcGFuaWVzIGluIHR"\
            "oZWlyIEd1aWRld2lyZSBwcm9qZWN0IHByb3Bvc2Fscw==",
          "Q29uZHVjdCBidXNpbmVzcyBwcm9jZXNzIGFuZCBwcm9kdWN0IHZhbHVlIGNvbnN1bHR"\
            "pbmcgd29ya3Nob3BzIGZvciBwcm9zcGVjdHMvY3VzdG9tZXJz",
          'UHJlcGFyZSB3cml0dGVuIHJlc3BvbnNlcyB0byBjdXN0b21lciBSRlAvUkZJcw==',
          "RGVtbyBlbnZpcm9ubWVudCBjb25maWd1cmF0aW9uIGFuZCBwcm9zcGVjdCByZXF1aXJ"\
            "lbWVudC1kcml2ZW4gZnVuY3Rpb24gZGV2ZWxvcG1lbnQ=",
          "UHJvZHVjdCBsb2NhbGl6YXRpb24gZGV2ZWxvcG1lbnQgZm9yIEphcGFuZXNlIG1hcmt"\
            "ldA==",
          'Q3VzdG9tZXIgcHJvZHVjdCB0cmFpbmluZw==',
          'SmFwYW4gYW5kIG92ZXJzZWFzIHRyYWRlIHNob3dzL21hcmtldGluZyBldmVudHM='
        )
        ########################################################################
        ### RNT
        ########################################################################
        move_down 15
        position "SW1wbGVtZW50YXRpb24gQ29uc3VsdGFudCwgUHJvZmVzc2lvbmFsIFNlcn"\
                 "ZpY2Vz"
        organisation 'UmlnaHQgTm93IFRlY2hub2xvZ2llcw=='
        period_and_location(
          period: 'SnVseSAyMDA3IOKAkyBBdWd1c3QgMjAwOCB8ICA=',
          location: 'VG9reW8sIEphcGFu',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc291cmNlPXNfcSZob"\
                "D1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjEwNS02MDI3JUU2JTlEJUIxJUU0JU"\
                "JBJUFDJUU5JTgzJUJEJUU2JUI4JUFGJUU1JThDJUJBJUU4JTk5JThFJUUzJTg"\
                "zJThFJUU5JTk2JTgwNC0zLTErJUU1JTlGJThFJUU1JUIxJUIxJUUzJTgzJTg4"\
                "JUUzJTgzJUE5JUUzJTgyJUI5JUUzJTgzJTg4JUUzJTgyJUJGJUUzJTgzJUFGJ"\
                "UUzJTgzJUJDKzI3JUU5JTlBJThFJmFxPSZzbGw9MzUuNjY0Njg4LDEzOS43ND"\
                "MzMDQmc3Nwbj0wLjAyODE3MiwwLjAzNTc5MSZ2cHNyYz02JmllPVVURjgmaHE"\
                "9JmhuZWFyPUphcGFuLCtUJUM1JThEa3klQzUlOEQtdG8sK01pbmF0by1rdSwr"\
                "VG9yYW5vbW9uLCslRUYlQkMlOTQlRTQlQjglODElRTclOUIlQUUlRUYlQkMlO"\
                "TMlRTIlODglOTIlRUYlQkMlOTErJUU1JTlGJThFJUU1JUIxJUIxJUUzJTgzJT"\
                "g4JUUzJTgzJUE5JUUzJTgyJUI5JUUzJTgzJTg4JUUzJTgyJUJGJUUzJTgzJUF"\
                "GJUUzJTgzJUJDJmxsPTM1LjY2NDY4OCwxMzkuNzQzMjYxJnNwbj0wLjAyODE3"\
                "MiwwLjAzNTc5MSZ0PW0mej0xNSZpd2xvYz1B"
        )

        move_up 40
        organisation_logo(
          organisation: 'rnt',
          origin: 435,
          width: 80,
          height: 40,
          fit: [110, 40],
          move_up: 40,
          bars: 7,
          size: 43
        )

        move_down 10
        text d "T24gYW5kIG9mZi1zaXRlIGN1c3RvbWVyIGltcGxlbWVudGF0aW9ucyBvZiBSaW"\
               "dodCBOb3cgQ2xvdWQgQ1JNIHByb2R1Y3Qu"

        bullet_list(
          "Q29uZmlybSBoaWdoLWxldmVsIGJ1c2luZXNzIHJlcXVpcmVtZW50cyBmZWFzaWJpbGl"\
            "0eSB3aXRoIHByZS1zYWxlcyB0ZWFt",
          "RG9jdW1lbnRhdGlvbjogcHJvamVjdCBjaGFydGVyLCBzY29wZSwgc2NoZWR1bGVzLCB"\
            "hbmQgdGVjaG5pY2FsIGRlc2lnbiBvZiBjdXN0b21pemF0aW9ucw==",
          "Q29uZHVjdCBpbmNlcHRpb24gcGhhc2UgcmVxdWlyZW1lbnRzIHdvcmtzaG9wcyBmb3I"\
            "gYnVzaW5lc3MgcHJvY2Vzc2VzLCB3b3JrZmxvd3MsIGFuZCBwcm9kdWN0IGltcGxl"\
            "bWVudGF0aW9uOyBkZXRlcm1pbmUgcG9zc2libGUgb3V0LW9mLXNjb3BlIGNoYW5nZ"\
            "SByZXF1ZXN0cyBhcyBuZWVkZWQ=",
          "Q29uZmlndXJlIGFuZCBzZXR1cCBwcm9kdWN0IHRlc3QgZW52aXJvbm1lbnQgZm9yIGN"\
            "saWVudCB0byB0cmFjayBwcm9qZWN0IHByb2dyZXNz",
          "TWFuYWdlLCBRQSwgYW5kIGxvY2FsaXplIGN1c3RvbWl6YXRpb24gd29yayBwZXJmb3J"\
            "tZWQgYnkgZW5naW5lZXJz",
          'RG9jdW1lbnQgYW5kIGV4ZWN1dGUgb24tc2l0ZSBVQVQgYW5kIHRyYWluaW5n',
          "UHJlcGFyZSBhbmQgZXhlY3V0ZSDigJxzaXRlIGdvLWxpdmXigJ0sIGFuYWx5emUgcml"\
            "za3MsIHByZXBhcmUgZmFsbGJhY2sgcGxhbnM=",
          "V29yayB3aXRoIGN1c3RvbWVyIHN1cHBvcnQgdG8gaGFuZGxlIGltcGxlbWVudGF0aW9"\
            "uLXJlbGF0ZWQgc3VwcG9ydCBpbmNpZGVudHM=",
          "SG9zdCwgbGluZ3Vpc3RpY2FsbHkgc3VwcG9ydCwgYW5kIGhhbmRsZSBKYXBhbiBpbW1"\
            "pZ3JhdGlvbiBvZiBvdmVyc2VhcyBwcm9qZWN0IG1lbWJlcnM="
        )
        ########################################################################
        ### SRA
        ########################################################################
        move_down 15
        position 'U29mdHdhcmUgRW5naW5lZXI='
        organisation 'U29mdHdhcmUgUmVzZWFyY2ggQXNzb2NpYXRlcyAoU1JBKQ=='
        period_and_location(
          period: 'QXByaWwgMjAwNiDigJMgSnVuZSAyMDA3IHwgIA==',
          location: 'VG9reW8sIEphcGFu',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjE3MS04NTEzJUU2JTlEJUIxJU"\
                "U0JUJBJUFDJUU5JTgzJUJEJUU4JUIxJThBJUU1JUIzJUI2JUU1JThDJUJBJUU"\
                "1JThEJTk3JUU2JUIxJUEwJUU4JUEyJThCMi0zMi04JmFxPSZzbGw9MzUuNzI2"\
                "NjAxLDEzOS43MTU1MDgmc3Nwbj0wLjAwNzAzOCwwLjAwODk0OCZ2cHNyYz0wJ"\
                "mllPVVURjgmaHE9JmhuZWFyPUphcGFuLCtUJUM1JThEa3klQzUlOEQtdG8sK1"\
                "Rvc2hpbWEta3UsK01pbmFtaWlrZWJ1a3VybywrJUVGJUJDJTkyJUU0JUI4JTg"\
                "xJUU3JTlCJUFFJUVGJUJDJTkzJUVGJUJDJTkyJUUyJTg4JTkyJUVGJUJDJTk4"\
                "JnQ9bSZ6PTE3Jml3bG9jPUE="
        )

        move_up 40
        organisation_logo(
          organisation: 'sra',
          origin: 415,
          width: 115,
          height: 40,
          fit: [110, 40],
          move_up: 40,
          bars: 10,
          size: 43
        )

        move_down 10
        text d "Q3VzdG9tIHNvZnR3YXJlIGRldmVsb3BtZW50IGluIHNtYWxsIHRlYW1zOyBkZX"\
               "NpZ24sIGNvZGluZywgdGVzdGluZywgZG9jdW1lbnRhdGlvbiwgZGVwbG95bWVu"\
               "dDsgaW50ZXJuYWwgc3lzdGVtIGFkbWluaXN0cmF0aW9uIGR1dGllcy4gIERldm"\
               "Vsb3BtZW50IHByZWRvbWluYW50bHkgZG9uZSB1c2luZyBQdXJlIFJ1YnkvUnVi"\
               "eSBvbiBSYWlscyBpbiBzbWFsbCB0ZWFtcyBvZiAyLTMgcGVvcGxlLg=="
        ########################################################################
        ### JET
        ########################################################################
        move_down 15
        position 'Q29vcmRpbmF0b3Igb2YgSW50ZXJuYXRpb25hbCBSZWxhdGlvbnMgKENJUik='
        organisation "SmFwYW4gRXhjaGFuZ2UgYW5kIFRlYWNoaW5nIFByb2dyYW1tZSAoSkVU"\
                     "KQ=="
        period_and_location(
          period: 'SnVseSAyMDAxIOKAkyBKdWx5IDIwMDQgfCAg',
          location: 'S29jaGksIEphcGFu',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5Mjc4MC0wODUwJUU5JUFCJTk4JU"\
                "U3JTlGJUE1JUU1JUI4JTgyJUU0JUI4JUI4JUUzJTgzJThFJUU1JTg2JTg1MSV"\
                "FNCVCOCU4MSVFNyU5QiVBRTclRTclOTUlQUE1MiVFNSU4RiVCNyZhcT0mc2xs"\
                "PS0zNC45NjE2OTIsMTM4LjYyMTM5OSZzc3BuPTAuMDU2ODM2LDAuMDcxNTgzJ"\
                "nZwc3JjPTYmaWU9VVRGOCZocT0maG5lYXI9SmFwYW4sK0slQzUlOERjaGkta2"\
                "VuLCtLJUM1JThEY2hpLXNoaSwrTWFydW5vdWNoaSwrJUVGJUJDJTkxJUU0JUI"\
                "4JTgxJUU3JTlCJUFFJUVGJUJDJTk3JUUyJTg4JTkyJUVGJUJDJTk1JUVGJUJD"\
                "JTkyJmxsPTMzLjU1OTQ1NiwxMzMuNTI4MzA0JnNwbj0wLjAxNDQ0OCwwLjAxN"\
                "zg5NiZ0PW0mej0xNiZpd2xvYz1B"
        )

        move_up 40
        organisation_logo(
          organisation: 'jet',
          origin: 435,
          width: 75,
          height: 35,
          fit: [110, 35],
          move_up: 34,
          bars: 8,
          size: 36
        )

        move_down 13
        text d "VHJhbnNsYXRpb24vaW50ZXJwcmV0aW5nOyBncmFzcy1yb290cyBjb21tdW5pdH"\
               "kgYWN0aXZpdGllcyBhbmQgam91cm5hbGlzbTsgcGxhbm5pbmcvaW1wbGVtZW50"\
               "aW5nIGludGVybmF0aW9uYWwgZXhjaGFuZ2UgcHJvamVjdHM7IGluYm91bmQgZ3"\
               "Vlc3QgaG9zcGl0YWxpdHk7IG91dGJvdW5kIHRvdXItZ3VpZGluZw=="
        ########################################################################
        ### SATC
        ########################################################################
        move_down 15
        position "SW50ZXJuYXRpb25hbCBNYXJrZXRpbmcgQXNzaXN0YW50IOKAkyBBc2lhIGFu"\
                 "ZCBKYXBhbg=="
        organisation 'U291dGggQXVzdHJhbGlhbiBUb3VyaXNtIENvbW1pc3Npb24='
        period_and_location(
          period: 'TWF5IDIwMDAg4oCTIE1heSAyMDAxIHwgIA==',
          location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPTUwK0dyZW5mZWxsK1N0LCtBZGVsYWlkZStTQS"\
                "ZhcT0mc2xsPS0zNC45MjQyMjMsMTM4LjYwMTcxMyZzc3BuPTAuMDU3MTQzLDA"\
                "uMDcxNTgzJnZwc3JjPTYmZz01MCtHcmVuZmVsbCtTdCwrQWRlbGFpZGUrU0Em"\
                "aWU9VVRGOCZocT0maG5lYXI9NTArR3JlbmZlbGwrU3QsK0FkZWxhaWRlK1Nvd"\
                "XRoK0F1c3RyYWxpYSs1MDAwJmxsPS0zNC45MjQwODIsMTM4LjYwMTY5MiZzcG"\
                "49MC4wMTQyMTUsMC4wMTc4OTYmdD1tJno9MTYmaXdsb2M9QQ=="
        )

        move_up 40
        organisation_logo(
          organisation: 'satc',
          origin: 430,
          width: 90,
          height: 40,
          fit: [110, 40],
          move_up: 40,
          bars: 8,
          size: 43
        )

        move_down 10
        text d "QXNzaXN0IHdpdGggdGhlIHByb21vdGlvbi9tYXJrZXRpbmcgb2YgU291dGggQX"\
               "VzdHJhbGlhIGFzIGEgdG91cmlzbSBkZXN0aW5hdGlvbiB0byBBc2lhIGFuZCBK"\
               "YXBhbi4="

        move_down 10
        stroke_horizontal_rule { color '666666' }
        ########################################################################
        ### MIT
        ########################################################################
        CLI.report('Creating education section...')

        move_down 10
        heading 'RWR1Y2F0aW9u'

        move_down 15
        position 'TWFzdGVycyBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5'
        organisation 'VW5pdmVyc2l0eSBvZiBTb3V0aCBBdXN0cmFsaWE='
        period_and_location(
          period: 'MjAwNC0yMDA1IHw=',
          location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPTU1K05vcnRoK1RlcnJhY2UsK0FkZWxhaWRlK1"\
                "NBKzUwMDAmc2xsPS0zNC45NjE2OTIsMTM4LjYyMTM5OSZzc3BuPTAuMDU2ODM"\
                "2LDAuMDcxNTgzJnZwc3JjPTYmaWU9VVRGOCZocT0maG5lYXI9NTUrTm9ydGgr"\
                "VGVycmFjZSwrQWRlbGFpZGUsK1NvdXRoK0F1c3RyYWxpYSs1MDAwJmxsPS0zN"\
                "C45MjIxODIsMTM4LjU5MDg1NiZzcG49MC4wMjg0MzIsMC4wMzU3OTEmdD1tJn"\
                "o9MTUmaXdsb2M9QQ=="
        )

        move_up 40
        organisation_logo(
          organisation: 'mit',
          origin: 210,
          width: 35,
          height: 40,
          fit: [35, 40],
          move_up: 35,
          bars: 3,
          size: 43
        )
        ########################################################################
        ### BIB
        ########################################################################
        move_up 38
        position 'QmFjaGVsb3Igb2YgSW50ZXJuYXRpb25hbCBCdXNpbmVzcw==', at: 280

        move_down 14
        organisation 'RmxpbmRlcnMgVW5pdmVyc2l0eQ==', at: 280
        move_down 13
        period_and_location(
          period: 'MTk5Ny0xOTk5IHw=',
          location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPVN0dXJ0K1JkLCtCZWRmb3JkK1BhcmsrU0ErNT"\
                "A0MiZhcT0mc2xsPS0zNC45MjIxODIsMTM4LjU5MDg1NiZzc3BuPTAuMDI4NDM"\
                "yLDAuMDM1NzkxJnZwc3JjPTYmaWU9VVRGOCZocT0maG5lYXI9U3R1cnQrUmQs"\
                "K0JlZGZvcmQrUGFyaytTb3V0aCtBdXN0cmFsaWErNTA0MiZsbD0tMzUuMDE2N"\
                "zgyLDEzOC41Njc5ODImc3BuPTAuMDU2Nzk4LDAuMDcxNTgzJnQ9bSZ6PTE0Jm"\
                "l3bG9jPUE=",
          at: 280
        )

        move_up 30
        organisation_logo(
          organisation: 'bib',
          origin: 490,
          width: 35,
          height: 40,
          fit: [35, 40],
          move_up: 40,
          bars: 3,
          size: 43
        )
        ########################################################################
        ### RYU
        ########################################################################
        move_down 20
        position 'U3R1ZGVudCBFeGNoYW5nZSBQcm9ncmFtbWU='
        organisation 'Unl1a29rdSBVbml2ZXJzaXR5'
        period_and_location(
          period: 'U2VwIDE5OTkgLSBGZWIgMjAwMCB8',
          location: 'S3lvdG8sIEphcGFu',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPSVFNCVCQSVBQyVFOSU4MyVCRCVFNSVCQSU5Qy"\
                "VFNCVCQSVBQyVFOSU4MyVCRCVFNSVCOCU4MiVFNCVCQyU4RiVFOCVBNiU4QiV"\
                "FNSU4QyVCQSVFNiVCNyVCMSVFOCU4RCU4OSVFNSVBMSU5QSVFNiU5QyVBQyVF"\
                "NyU5NCVCQSVFRiVCQyU5NiVFRiVCQyU5NyZhcT0mc2xsPS0zNS4wMTY3ODIsM"\
                "TM4LjU2Nzk4MiZzc3BuPTAuMDU2Nzk4LDAuMDcxNTgzJnZwc3JjPTYmZz1TdH"\
                "VydCtSZCwrQmVkZm9yZCtQYXJrK1NvdXRoK0F1c3RyYWxpYSs1MDQyJmllPVV"\
                "URjgmaHE9JmhuZWFyPUphcGFuLCtLeSVDNSU4RHRvLWZ1LCtLeSVDNSU4RHRv"\
                "LXNoaSwrRnVzaGltaS1rdSwrRnVrYWt1c2ErVHN1a2Ftb3RvY2glQzUlOEQsK"\
                "yVFRiVCQyU5NiVFRiVCQyU5NyZsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNwbj"\
                "0wLjAwNzEwNCwwLjAwODk0OCZ0PW0mej0xNyZpd2xvYz1B"
        )

        move_up 40
        organisation_logo(
          organisation: 'ryu',
          origin: 214,
          width: 32,
          height: 40,
          fit: [32, 40],
          move_up: 40,
          bars: 3,
          size: 40
        )
        ########################################################################
        ### TAFE
        ########################################################################
        move_up 38
        position 'Q2VydGlmaWNhdGUgSUkgaW4gVG91cmlzbQ==', at: 280
        move_down 14
        organisation 'QWRlbGFpZGUgVEFGRQ==', at: 280

        move_down 13
        period_and_location(
          period: 'TWF5IDIwMDAgLSBNYXkgMjAwMSB8',
          location: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
          link: "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
                "SZobD1lbiZnZW9jb2RlPSZxPTEyMCtDdXJyaWUrU3RyZWV0K0FERUxBSURFK1"\
                "NBKzUwMDAmYXE9JnNsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNzcG49MC4wMDc"\
                "xMDQsMC4wMDg5NDgmdnBzcmM9NiZpZT1VVEY4JmhxPSZobmVhcj0xMjArQ3Vy"\
                "cmllK1N0LCtBZGVsYWlkZStTb3V0aCtBdXN0cmFsaWErNTAwMCZ0PW0mbGw9L"\
                "TM0LjkyNDU0LDEzOC41OTU1MTImc3BuPTAuMDE0MjE1LDAuMDE3ODk2Jno9MT"\
                "YmaXdsb2M9QQ==",
          at: 280
        )

        move_up 23
        organisation_logo(
          organisation: 'tafe',
          origin: 490,
          width: 37,
          height: 35,
          fit: [37, 35],
          move_up: 19,
          bars: 5,
          size: 28
        )
      end
    end
  end
end