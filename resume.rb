# encoding: utf-8
DOCUMENT_NAME = "Resume"
################################################################################
### This resume lives online at https://github.com/paulfioravanti/resume
### Instructions:
### 1. Make sure you run this with Ruby 1.9.2 or greater (1.8.7 will not work)
### 2. Please let the script install the Prawn gem for PDF generation if you
###    don't have it already.  Otherwise, please contact me for a resume.
### 3. The script will pull down some small images from Flickr, so please ensure
###    you have an internet connection.
### 4. Run the script: $ ruby resume.rb
################################################################################

################################################################################
### Script helper methods
################################################################################
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text)
  colorize(text, 31)
end

def yellow(text)
  colorize(text, 33)
end

def green(text)
  colorize(text, 32)
end

def cyan(text)
  colorize(text, 36)
end

def permission_granted?
  gets.chomp.match(%r{\A(y|yes)\z}i)
end

def required_gem_available?(name, version)
  Gem::Specification.find_by_name(name).version >= Gem::Version.new(version)
rescue Gem::LoadError # gem not installed
  false
end

def d(string) # decode string
  Base64.strict_decode64(string)
end

def open_document
  case RUBY_PLATFORM
  when %r(darwin)
    %x(open #{DOCUMENT_NAME}.pdf)
  when %r(linux)
    %x(xdg-open #{DOCUMENT_NAME}.pdf)
  when %r(windows)
    %x(cmd /c "start #{DOCUMENT_NAME}.pdf")
  else
    puts yellow "Sorry, I can't figure out how to open the resume on\n"\
                "this computer. Please open it yourself."
  end
end

def bullet_list(*items)
  table_data = []
  items.each do |item|
    table_data << ["•", d(item)]
  end
  table(table_data, cell_style: { borders: [] })
end

def social_media_links(image_links)
  x_position = 0
  image_links.each do |image_link|
    move_up image_link[:move_up] || 46.25
    bounding_box([x_position, cursor], width: 35) do
      image open(image_link[:image]), fit: [35, 35], align: :center
      move_up 35
      transparent(0) do
        formatted_text([{
          text: "|||",
          size: 40,
          link: d(image_link[:link])
        }], align: :center)
      end
    end
    x_position += 45
  end
end

def heading(string)
  formatted_text([{ text: d(string), styles: [:bold], color: "666666" }])
end

def name(string)
  font("Times-Roman", size: 20) { text d(string) }
end

def description(ruby, rest)
  formatted_text([
    { text: d(ruby), color: "85200C" },
    { text: d(rest) }
  ], size: 14)
end

################################################################################
### Get dependent gems if not available
################################################################################
unless required_gem_available?('prawn', '1.0.0.rc2')
  print yellow "May I please install version 1.0.0.rc2 of the 'Prawn'\n"\
               "Ruby gem to help me generate a PDF (Y/N)? "
  if permission_granted?
    puts green "Thank you kindly :-)"
    puts "Installing Prawn gem version 1.0.0.rc2..."
    begin
      %x(gem install prawn -v 1.0.0.rc2)
    rescue
      puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
               "Either try again or ask me directly for a PDF copy of"\
               " my resume."
      exit
    end
    puts green "Prawn gem successfully installed."
    Gem.clear_paths # Reset the dir and path values so Prawn can be required
  else
    puts red "Sorry, I won't be able to generate a PDF without this\n"\
             "specific version of the Prawn gem.\n"\
             "Please ask me directly for a PDF copy of my resume."
    exit
  end
end

################################################################################
### Generate document
################################################################################
require 'base64'
require 'prawn'
require 'open-uri'

Prawn::Document.generate("#{DOCUMENT_NAME}.pdf",
  margin_top: 0.75, margin_bottom: 0.75, margin_left: 1, margin_right: 1,
  background: open(
    "http://farm6.staticflickr.com/5453/8801916021_3ac1df6072_o_d.jpg"),
  repeat: true) do

  puts "Generating PDF.  This shouldn't take longer than a few seconds..."

  name "UGF1bCBGaW9yYXZhbnRp"
  description "UnVieSBEZXZlbG9wZXIg",
              "YW5kIEluZm9ybWF0aW9uIFRlY2hub2xvZ3kgU2VydmljZXMgUHJvZmVzc2lvbmFs"

################################################################################
### Social Media
################################################################################
  puts "Creating social media links section..."

  move_down 5
  social_media_links([
    {
      image: "http://farm3.staticflickr.com/2826/8753727736_2a7a294527_m.jpg",
      link: "bWFpbHRvOnBhdWwuZmlvcmF2YW50aUBnbWFpbC5jb20=",
      move_up: 0
    },
    {
      image: "http://farm4.staticflickr.com/3687/8809717292_4938937a94_m.jpg",
      link: "aHR0cDovL2xpbmtlZGluLmNvbS9pbi9wYXVsZmlvcmF2YW50aQ=="
    },
    {
      image: "http://farm4.staticflickr.com/3828/8799239149_d23e4acff0_m.jpg",
      link: "aHR0cDovL2dpdGh1Yi5jb20vcGF1bGZpb3JhdmFudGk="
    },
    {
      image: "http://farm3.staticflickr.com/2815/8799253647_e4ec3ab1bc_m.jpg",
      link: "aHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3VzZXJzLzU2Nzg2My9wYXVsLWZpb3Jh"\
            "dmFudGk="
    },
    {
      image: "http://farm8.staticflickr.com/7404/8799250189_4125b90a14_m.jpg",
      link: "aHR0cHM6Ly9zcGVha2VyZGVjay5jb20vcGF1bGZpb3JhdmFudGk="
    },
    {
      image: "http://farm9.staticflickr.com/8546/8809862216_0cdd40c3dc_m.jpg",
      link: "aHR0cHM6Ly92aW1lby5jb20vcGF1bGZpb3JhdmFudGk="
    },
    {
      image: "http://farm4.staticflickr.com/3714/9015339024_0651daf2c4_m.jpg",
      link: "aHR0cDovL3d3dy5jb2Rlc2Nob29sLmNvbS91c2Vycy9wYXVsZmlvcmF2YW50aQ=="
    },
    {
      image: "http://farm3.staticflickr.com/2837/8799235993_26a7d17540_m.jpg",
      link: "aHR0cHM6Ly90d2l0dGVyLmNvbS9wZWZpb3JhdmFudGk="
    },
    {
      image: "http://farm4.staticflickr.com/3752/8809826162_e4d765d15b_m.jpg",
      link: "aHR0cDovL3BhdWxmaW9yYXZhbnRpLmNvbS9hYm91dA=="
    }
  ])

  stroke_horizontal_rule { color "666666" }

  puts "Creating employment history section..."

  move_down 10
  heading "RW1wbG95bWVudCBIaXN0b3J5"

################################################################################
### RC
################################################################################
  move_down 10
  formatted_text([{ text: d("U2VuaW9yIERldmVsb3Blcg=="), styles: [:bold] }])
  formatted_text([
    {
      text: d("UmF0ZUNpdHkuY29tLmF1"),
      styles: [:bold], size: 11
    }
  ])
  formatted_text([
    { text: d("SnVseSAyMDEzIC0gUHJlc2VudCB8") },
    {
      text: d("U3lkbmV5LCBBdXN0cmFsaWE="),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9xPTYxK0xhdmVuZGVyK1N"\
              "0K01pbHNvbnMrUG9pbnQrTlNXKzIwNjEmaGw9ZW4mbGw9LTMzLjg1MDYwMiwxNT"\
              "EuMjEzMTYmc3BuPTAuMDI3MjY1LDAuMDM4OTY3JnNsbD0tMzMuODQzNjU5LDE1M"\
              "S4yMDk5NDkmc3Nwbj0wLjAwNjgxNywwLjAwOTc0MiZobmVhcj02MStMYXZlbmRl"\
              "citTdCwrTWlsc29ucytQb2ludCtOZXcrU291dGgrV2FsZXMrMjA2MSZ0PW0mej0"\
              "xNQ==")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([415, cursor], width: 115, height: 40) do
    image open(
      "http://farm6.staticflickr.com/5484/9192095974_b49a1fc142_m.jpg"),
      fit: [110, 40], align: :center
    move_up 40
    transparent(0) do
      formatted_text([{
        text: "||||||||||",
        size: 43,
        link: d("aHR0cDovL3d3dy5yYXRlY2l0eS5jb20uYXUv")
      }])
    end
  end

  move_down 10
  text d "UnVieSBvbiBSYWlscyBkZXZlbG9wZXIgZm9yIFJhdGVDaXR5LmNvbS5hdSBmaW5hbmNp"\
         "YWwgcHJvZHVjdHMgYW5kIHNlcnZpY2VzIGNvbXBhcmlzb24gd2Vic2l0ZS4="

  bullet_list(
    "T3VyIHRlYW0gaXMgZmllcmNlbHkgQWdpbGUsIHdpdGggdGlnaHQgZGV2ZWxvcG1lbnQgZmVlZ"\
      "GJhY2sgbG9vcHMgb2Ygb25lIHdlZWssIG1lYXN1cmVkIGFuZCBtYW5hZ2VkIHRyYW5zcGFy"\
      "ZW50bHkgaW4gVHJlbGxvIGFuZCBkYWlseSBzdGFuZC11cCBtZWV0aW5ncw==",
    "V2UgYWN0aXZlbHkgdXNlIFJTcGVjIGZvciB0ZXN0LWRyaXZlbiBkZXZlbG9wbWVudCwgYW5kI"\
      "G1lYXN1cmUgb3VyIGNvZGUgcXVhbGl0eSB1c2luZyBzZXJ2aWNlcyBsaWtlIENvZGUgQ2xp"\
      "bWF0ZSBhbmQgQ292ZXJhbGxz",
    "R2l0aHViIHB1bGwgcmVxdWVzdHMsIGNvbnRpbnVvdXMgaW50ZWdyYXRpb24gd2l0aCBUcmF2a"\
      "XMgUHJvLCBwZWVyIGNvZGUgcmV2aWV3LCBhbmQgY29udGludW91cyBzdGFnaW5nL3Byb2R1"\
      "Y3Rpb24gZGVwbG95cyBhcmUgY2VudHJhbCB0byBvdXIgZXZlcnlkYXkgZGV2ZWxvcG1lbnQ"\
      "gd29ya2Zsb3c=",
    "V2UgZ2V0IHN0dWZmIGRvbmUsIGdldCBpdCBsaXZlIGZhc3QsIGFuZCBzdHJpdmUgdG8gZ2V0I"\
      "GJldHRlcg=="
  )

################################################################################
### FL
################################################################################
  move_down 15
  formatted_text([{ text: d("UnVieSBEZXZlbG9wZXI="), styles: [:bold] }])
  formatted_text([{ text: d("RnJlZWxhbmNl"), styles: [:bold], size: 11 }])
  formatted_text([
    { text: d("U2VwdGVtYmVyIDIwMTIg4oCTIEp1bHkgMjAxMyB8ICA=") },
    {
      text: d("QWRlbGFpZGUsIEF1c3RyYWxpYQ=="),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc291cmNlPXNfcSZobD1"\
              "lbiZnZW9jb2RlPSZxPWFkZWxhaWRlLCthdXN0cmFsaWEmYXE9JnNsbD0tMzQuOT"\
              "YxNjkyLDEzOC42MjEzOTkmc3Nwbj0wLjA1NjgzNiwwLjA3MTU4MyZ2cHNyYz00J"\
              "mllPVVURjgmaHE9JmhuZWFyPUFkZWxhaWRlK1NvdXRoK0F1c3RyYWxpYSwrQXVz"\
              "dHJhbGlhJnQ9bSZ6PTkmaXdsb2M9QQ==")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([440, cursor], width: 37, height: 33) do
    image open(
      "http://farm4.staticflickr.com/3793/8799953079_33cfdc0def_m.jpg"),
      fit: [31, 31], align: :center
    move_up 30
    transparent(0) do
      formatted_text([{
        text: "||||",
        size: 34,
        link: d("aHR0cDovL3d3dy5ydWJ5LWxhbmcub3JnL2VuLw==")
      }])
    end
  end

  move_up 33
  bounding_box([480, cursor], width: 32, height: 34) do
    image open(
      "http://farm4.staticflickr.com/3681/8810534562_dfc34ea70c_m.jpg"),
      fit: [31, 31], align: :center
    move_up 30
    transparent(0) do
      formatted_text([{
        text: "|||",
        size: 35,
        link: d("aHR0cDovL3J1YnlvbnJhaWxzLm9yZy8=")
      }])
    end
  end

  move_down 15
  text d "UGFydC10aW1lIGFuZCBwcm9qZWN0LWJhc2VkIFJ1Ynkgb24gUmFpbHMgd29yayBmb3Ig"\
         "bG9jYWwgc3RhcnQtdXAgYW5kIHNtYWxsIGNvbXBhbmllcy4="

################################################################################
### GW
################################################################################
  move_down 15
  formatted_text([{ text: d("UHJlLXNhbGVzIENvbnN1bHRhbnQ="), styles: [:bold] }])
  formatted_text([
    { text: d("R3VpZGV3aXJlIFNvZnR3YXJl"), styles: [:bold], size: 11 }
  ])
  formatted_text([
    { text: d("SmFudWFyeSAyMDA5IOKAkyBTZXB0ZW1iZXIgMjAxMSB8ICA=") },
    {
      text: d("VG9reW8sIEphcGFu"),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc291cmNlPXNfcSZobD1"\
              "lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjEwMC0wMDA2KyslRTYlOUQlQjElRTQlQk"\
              "ElQUMlRTklODMlQkQlRTUlOEQlODMlRTQlQkIlQTMlRTclOTQlQjAlRTUlOEMlQ"\
              "kElRTYlOUMlODklRTYlQTUlQkQlRTclOTQlQkEyLTctMSsrJUU2JTlDJTg5JUU2"\
              "JUE1JUJEJUU3JTk0JUJBJUUzJTgyJUE0JUUzJTgzJTg4JUUzJTgyJUI3JUUzJTg"\
              "yJUEyKzEyJUU5JTlBJThFJmFxPSZzbGw9LTM0LjkyODYyMSwxMzguNTk5OTU5Jn"\
              "NzcG49MS44MTk0MzYsMi4yOTA2NDkmdnBzcmM9MCZnPWFkZWxhaWRlLCthdXN0c"\
              "mFsaWEmaWU9VVRGOCZocT0lRTMlODAlOTIxMDAtMDAwNisrJUU2JTlEJUIxJUU0"\
              "JUJBJUFDJUU5JTgzJUJEJUU1JThEJTgzJUU0JUJCJUEzJUU3JTk0JUIwJUU1JTh"\
              "DJUJBJUU2JTlDJTg5JUU2JUE1JUJEJUU3JTk0JUJBMi03LTErKyVFNiU5QyU4OS"\
              "VFNiVBNSVCRCVFNyU5NCVCQSVFMyU4MiVBNCVFMyU4MyU4OCVFMyU4MiVCNyVFM"\
              "yU4MiVBMisxMiVFOSU5QSU4RSZ0PW0mej0xNSZpd2xvYz1BJmNpZD0xNzQ4MjYw"\
              "NDQzMTMwNjkxMzEzMw==")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([415, cursor], width: 118, height: 39) do
    image open(
      "http://farm8.staticflickr.com/7376/8812488914_f0bfd0a841_m.jpg"),
      fit: [110, 40], align: :center
    move_up 32
    transparent(0) do
      formatted_text([{
        text: "|||||||||||",
        size: 41,
        link: d("aHR0cDovL3d3dy5ndWlkZXdpcmUuY29tLw==")
      }])
    end
  end

  move_down 10
  text d "Q29tcGxleCBzYWxlcyBvZiBHdWlkZXdpcmUgQ2xhaW1DZW50ZXIgaW5zdXJhbmNlIGNs"\
         "YWltIGhhbmRsaW5nIHN5c3RlbSB0byBidXNpbmVzcyBhbmQgSVQgZGVwYXJ0bWVudHMg"\
         "b2YgUHJvcGVydHkgJiBDYXN1YWx0eSBpbnN1cmFuY2UgY29tcGFuaWVzLg=="

  bullet_list(
    "UGVyZm9ybSB2YWx1ZS1iYXNlZCBhbmQgdGVjaG5vbG9neS1mb2N1c2VkIHByZXNlbnRhdGl"\
      "vbnMgYW5kIHByb2R1Y3QgZGVtb25zdHJhdGlvbnM=",
    "Q29uZHVjdCBBZ2lsZS1kcml2ZW4gUHJvb2Ygb2YgQ29uY2VwdCB3b3Jrc2hvcHMgZm9yIHB"\
      "yb3NwZWN0cw==",
    "V29yayB3aXRoIFN5c3RlbSBJbnRlZ3JhdG9yIHBhcnRuZXIgY29tcGFuaWVzIGluIHRoZWl"\
      "yIEd1aWRld2lyZSBwcm9qZWN0IHByb3Bvc2Fscw==",
    "Q29uZHVjdCBidXNpbmVzcyBwcm9jZXNzIGFuZCBwcm9kdWN0IHZhbHVlIGNvbnN1bHRpbmc"\
      "gd29ya3Nob3BzIGZvciBwcm9zcGVjdHMvY3VzdG9tZXJz",
    "UHJlcGFyZSB3cml0dGVuIHJlc3BvbnNlcyB0byBjdXN0b21lciBSRlAvUkZJcw==",
    "RGVtbyBlbnZpcm9ubWVudCBjb25maWd1cmF0aW9uIGFuZCBwcm9zcGVjdCByZXF1aXJlbWV"\
      "udC1kcml2ZW4gZnVuY3Rpb24gZGV2ZWxvcG1lbnQ=",
    "UHJvZHVjdCBsb2NhbGl6YXRpb24gZGV2ZWxvcG1lbnQgZm9yIEphcGFuZXNlIG1hcmtldA==",
    "Q3VzdG9tZXIgcHJvZHVjdCB0cmFpbmluZw==",
    "SmFwYW4gYW5kIG92ZXJzZWFzIHRyYWRlIHNob3dzL21hcmtldGluZyBldmVudHM="
  )

################################################################################
### RNT
################################################################################
  move_down 15
  formatted_text([
    {
      text: d("SW1wbGVtZW50YXRpb24gQ29uc3VsdGFudCwgUHJvZmVzc2lvbmFsIFNlcn"\
              "ZpY2Vz"),
      styles: [:bold]
    }
  ])
  formatted_text([
    { text: d("UmlnaHQgTm93IFRlY2hub2xvZ2llcw=="), styles: [:bold], size: 11 }
  ])
  formatted_text([
    { text: d("SnVseSAyMDA3IOKAkyBBdWd1c3QgMjAwOCB8ICA=") },
    {
      text: d("VG9reW8sIEphcGFu"),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc291cmNlPXNfcSZobD1"\
              "lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjEwNS02MDI3JUU2JTlEJUIxJUU0JUJBJU"\
              "FDJUU5JTgzJUJEJUU2JUI4JUFGJUU1JThDJUJBJUU4JTk5JThFJUUzJTgzJThFJ"\
              "UU5JTk2JTgwNC0zLTErJUU1JTlGJThFJUU1JUIxJUIxJUUzJTgzJTg4JUUzJTgz"\
              "JUE5JUUzJTgyJUI5JUUzJTgzJTg4JUUzJTgyJUJGJUUzJTgzJUFGJUUzJTgzJUJ"\
              "DKzI3JUU5JTlBJThFJmFxPSZzbGw9MzUuNjY0Njg4LDEzOS43NDMzMDQmc3Nwbj"\
              "0wLjAyODE3MiwwLjAzNTc5MSZ2cHNyYz02JmllPVVURjgmaHE9JmhuZWFyPUphc"\
              "GFuLCtUJUM1JThEa3klQzUlOEQtdG8sK01pbmF0by1rdSwrVG9yYW5vbW9uLCsl"\
              "RUYlQkMlOTQlRTQlQjglODElRTclOUIlQUUlRUYlQkMlOTMlRTIlODglOTIlRUY"\
              "lQkMlOTErJUU1JTlGJThFJUU1JUIxJUIxJUUzJTgzJTg4JUUzJTgzJUE5JUUzJT"\
              "gyJUI5JUUzJTgzJTg4JUUzJTgyJUJGJUUzJTgzJUFGJUUzJTgzJUJDJmxsPTM1L"\
              "jY2NDY4OCwxMzkuNzQzMjYxJnNwbj0wLjAyODE3MiwwLjAzNTc5MSZ0PW0mej0x"\
              "NSZpd2xvYz1B")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([435, cursor], width: 80, height: 40) do
    image open(
      "http://farm8.staticflickr.com/7326/8801904137_e6008ee907_m.jpg"),
      fit: [110, 40], align: :center
    move_up 40
    transparent(0) do
      formatted_text([{
        text: "|||||||",
        size: 43,
        link: d("aHR0cDovL3d3dy5vcmFjbGUuY29tL3VzL3Byb2R1Y3RzL2FwcGxpY2F0aW9uc"\
                "y9yaWdodG5vdy9vdmVydmlldy9pbmRleC5odG1s")
      }])
    end
  end

  move_down 10
  text d "T24gYW5kIG9mZi1zaXRlIGN1c3RvbWVyIGltcGxlbWVudGF0aW9ucyBvZiBSaWdodCBO"\
         "b3cgQ2xvdWQgQ1JNIHByb2R1Y3Qu"

  bullet_list(
    "Q29uZmlybSBoaWdoLWxldmVsIGJ1c2luZXNzIHJlcXVpcmVtZW50cyBmZWFzaWJpbGl0eSB3"\
      "aXRoIHByZS1zYWxlcyB0ZWFt",
    "RG9jdW1lbnRhdGlvbjogcHJvamVjdCBjaGFydGVyLCBzY29wZSwgc2NoZWR1bGVzLCBhbmQg"\
      "dGVjaG5pY2FsIGRlc2lnbiBvZiBjdXN0b21pemF0aW9ucw==",
    "Q29uZHVjdCBpbmNlcHRpb24gcGhhc2UgcmVxdWlyZW1lbnRzIHdvcmtzaG9wcyBmb3IgYnVz"\
      "aW5lc3MgcHJvY2Vzc2VzLCB3b3JrZmxvd3MsIGFuZCBwcm9kdWN0IGltcGxlbWVudGF0aW"\
      "9uOyBkZXRlcm1pbmUgcG9zc2libGUgb3V0LW9mLXNjb3BlIGNoYW5nZSByZXF1ZXN0cyBh"\
      "cyBuZWVkZWQ=",
    "Q29uZmlndXJlIGFuZCBzZXR1cCBwcm9kdWN0IHRlc3QgZW52aXJvbm1lbnQgZm9yIGNsaWVu"\
      "dCB0byB0cmFjayBwcm9qZWN0IHByb2dyZXNz",
    "TWFuYWdlLCBRQSwgYW5kIGxvY2FsaXplIGN1c3RvbWl6YXRpb24gd29yayBwZXJmb3JtZWQg"\
      "YnkgZW5naW5lZXJz",
    "RG9jdW1lbnQgYW5kIGV4ZWN1dGUgb24tc2l0ZSBVQVQgYW5kIHRyYWluaW5n",
    "UHJlcGFyZSBhbmQgZXhlY3V0ZSDigJxzaXRlIGdvLWxpdmXigJ0sIGFuYWx5emUgcmlza3Ms"\
      "IHByZXBhcmUgZmFsbGJhY2sgcGxhbnM=",
    "V29yayB3aXRoIGN1c3RvbWVyIHN1cHBvcnQgdG8gaGFuZGxlIGltcGxlbWVudGF0aW9uLXJl"\
      "bGF0ZWQgc3VwcG9ydCBpbmNpZGVudHM=",
    "SG9zdCwgbGluZ3Vpc3RpY2FsbHkgc3VwcG9ydCwgYW5kIGhhbmRsZSBKYXBhbiBpbW1pZ3Jh"\
      "dGlvbiBvZiBvdmVyc2VhcyBwcm9qZWN0IG1lbWJlcnM="
  )

################################################################################
### SRA
################################################################################
  move_down 15
  formatted_text([{ text: d("U29mdHdhcmUgRW5naW5lZXI="), styles: [:bold] }])
  formatted_text([
    {
      text: d("U29mdHdhcmUgUmVzZWFyY2ggQXNzb2NpYXRlcyAoU1JBKQ=="),
      styles: [:bold], size: 11
    }
  ])
  formatted_text([
    { text: d("QXByaWwgMjAwNiDigJMgSnVuZSAyMDA3IHwgIA==") },
    {
      text: d("VG9reW8sIEphcGFu"),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjE3MS04NTEzJUU2JTlEJUIxJUU0JU"\
              "JBJUFDJUU5JTgzJUJEJUU4JUIxJThBJUU1JUIzJUI2JUU1JThDJUJBJUU1JThEJ"\
              "Tk3JUU2JUIxJUEwJUU4JUEyJThCMi0zMi04JmFxPSZzbGw9MzUuNzI2NjAxLDEz"\
              "OS43MTU1MDgmc3Nwbj0wLjAwNzAzOCwwLjAwODk0OCZ2cHNyYz0wJmllPVVURjg"\
              "maHE9JmhuZWFyPUphcGFuLCtUJUM1JThEa3klQzUlOEQtdG8sK1Rvc2hpbWEta3"\
              "UsK01pbmFtaWlrZWJ1a3VybywrJUVGJUJDJTkyJUU0JUI4JTgxJUU3JTlCJUFFJ"\
              "UVGJUJDJTkzJUVGJUJDJTkyJUUyJTg4JTkyJUVGJUJDJTk4JnQ9bSZ6PTE3Jml3"\
              "bG9jPUE=")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([415, cursor], width: 115, height: 40) do
    image open(
      "http://farm4.staticflickr.com/3801/8801903945_723a5d7276_m.jpg"),
      fit: [110, 40], align: :center
    move_up 40
    transparent(0) do
      formatted_text([{
        text: "||||||||||",
        size: 43,
        link: d("aHR0cDovL3d3dy5zcmEuY28uanAvaW5kZXgtZW4uc2h0bWw=")
      }])
    end
  end

  move_down 10
  text d "Q3VzdG9tIHNvZnR3YXJlIGRldmVsb3BtZW50IGluIHNtYWxsIHRlYW1zOyBkZXNpZ24"\
         "sIGNvZGluZywgdGVzdGluZywgZG9jdW1lbnRhdGlvbiwgZGVwbG95bWVudDsgaW50ZX"\
         "JuYWwgc3lzdGVtIGFkbWluaXN0cmF0aW9uIGR1dGllcy4gIERldmVsb3BtZW50IHByZ"\
         "WRvbWluYW50bHkgZG9uZSB1c2luZyBQdXJlIFJ1YnkvUnVieSBvbiBSYWlscyBpbiBz"\
         "bWFsbCB0ZWFtcyBvZiAyLTMgcGVvcGxlLg=="

################################################################################
### JET
################################################################################
  move_down 15
  formatted_text([
    {
      text: d("Q29vcmRpbmF0b3Igb2YgSW50ZXJuYXRpb25hbCBSZWxhdGlvbnMgKENJUik="),
      styles: [:bold]
    }
  ])
  formatted_text([
    {
      text: d("SmFwYW4gRXhjaGFuZ2UgYW5kIFRlYWNoaW5nIFByb2dyYW1tZSAoSkVUKQ=="),
      styles: [:bold], size: 11
    }
  ])
  formatted_text([
    { text: d("SnVseSAyMDAxIOKAkyBKdWx5IDIwMDQgfCAg") },
    {
      text: d("S29jaGksIEphcGFu"),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5Mjc4MC0wODUwJUU5JUFCJTk4JUU3JT"\
              "lGJUE1JUU1JUI4JTgyJUU0JUI4JUI4JUUzJTgzJThFJUU1JTg2JTg1MSVFNCVCO"\
              "CU4MSVFNyU5QiVBRTclRTclOTUlQUE1MiVFNSU4RiVCNyZhcT0mc2xsPS0zNC45"\
              "NjE2OTIsMTM4LjYyMTM5OSZzc3BuPTAuMDU2ODM2LDAuMDcxNTgzJnZwc3JjPTY"\
              "maWU9VVRGOCZocT0maG5lYXI9SmFwYW4sK0slQzUlOERjaGkta2VuLCtLJUM1JT"\
              "hEY2hpLXNoaSwrTWFydW5vdWNoaSwrJUVGJUJDJTkxJUU0JUI4JTgxJUU3JTlCJ"\
              "UFFJUVGJUJDJTk3JUUyJTg4JTkyJUVGJUJDJTk1JUVGJUJDJTkyJmxsPTMzLjU1"\
              "OTQ1NiwxMzMuNTI4MzA0JnNwbj0wLjAxNDQ0OCwwLjAxNzg5NiZ0PW0mej0xNiZ"\
              "pd2xvYz1B")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([435, cursor], width: 75, height: 35) do
    image open(
      "http://farm4.staticflickr.com/3690/8801904135_37197a468c_m.jpg"),
      fit: [110, 35], align: :center
    move_up 34
    transparent(0) do
      formatted_text([{
        text: "||||||||",
        size: 36,
        link: d("aHR0cDovL3d3dy5qZXRwcm9ncmFtbWUub3JnL2UvYXNwaXJpbmcvcG9zaXRpb"\
                "25zLmh0bWw=")
      }])
    end
  end

  move_down 13
  text d "VHJhbnNsYXRpb24vaW50ZXJwcmV0aW5nOyBncmFzcy1yb290cyBjb21tdW5pdHkgYWN0"\
         "aXZpdGllcyBhbmQgam91cm5hbGlzbTsgcGxhbm5pbmcvaW1wbGVtZW50aW5nIGludGVy"\
         "bmF0aW9uYWwgZXhjaGFuZ2UgcHJvamVjdHM7IGluYm91bmQgZ3Vlc3QgaG9zcGl0YWxp"\
         "dHk7IG91dGJvdW5kIHRvdXItZ3VpZGluZw=="

################################################################################
### SATC
################################################################################
  move_down 15
  formatted_text([
    {
      text: d("SW50ZXJuYXRpb25hbCBNYXJrZXRpbmcgQXNzaXN0YW50IOKAkyBBc2lhIGFuZCB"\
              "KYXBhbg=="),
      styles: [:bold]
    }
  ])
  formatted_text([
    {
      text: d("U291dGggQXVzdHJhbGlhbiBUb3VyaXNtIENvbW1pc3Npb24="),
      styles: [:bold], size: 11
    }
  ])
  formatted_text([
    { text: d("TWF5IDIwMDAg4oCTIE1heSAyMDAxIHwgIA==") },
    {
      text: d("QWRlbGFpZGUsIEF1c3RyYWxpYQ=="),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPTUwK0dyZW5mZWxsK1N0LCtBZGVsYWlkZStTQSZhcT"\
              "0mc2xsPS0zNC45MjQyMjMsMTM4LjYwMTcxMyZzc3BuPTAuMDU3MTQzLDAuMDcxN"\
              "TgzJnZwc3JjPTYmZz01MCtHcmVuZmVsbCtTdCwrQWRlbGFpZGUrU0EmaWU9VVRG"\
              "OCZocT0maG5lYXI9NTArR3JlbmZlbGwrU3QsK0FkZWxhaWRlK1NvdXRoK0F1c3R"\
              "yYWxpYSs1MDAwJmxsPS0zNC45MjQwODIsMTM4LjYwMTY5MiZzcG49MC4wMTQyMT"\
              "UsMC4wMTc4OTYmdD1tJno9MTYmaXdsb2M9QQ==")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([430, cursor], width: 90, height: 40) do
    image open(
      "http://farm4.staticflickr.com/3804/8801903991_103f5a47f8_m.jpg"),
      fit: [110, 40], align: :center
    move_up 40
    transparent(0) do
      formatted_text([{
        text: "||||||||",
        size: 43,
        link: d("aHR0cDovL3d3dy5zb3V0aGF1c3RyYWxpYS5jb20v")
      }])
    end
  end

  move_down 10
  text d "QXNzaXN0IHdpdGggdGhlIHByb21vdGlvbi9tYXJrZXRpbmcgb2YgU291dGggQXVzdHJh"\
         "bGlhIGFzIGEgdG91cmlzbSBkZXN0aW5hdGlvbiB0byBBc2lhIGFuZCBKYXBhbi4="

  move_down 10
  stroke_horizontal_rule { color "666666" }

  puts "Creating education section..."

  move_down 10
  heading "RWR1Y2F0aW9u"

################################################################################
### MIT
################################################################################
  move_down 15
  formatted_text([
    {
      text: d("TWFzdGVycyBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5"),
      styles: [:bold]
    }
  ])
  formatted_text([
    {
      text: d("VW5pdmVyc2l0eSBvZiBTb3V0aCBBdXN0cmFsaWE="),
      styles: [:bold], size: 11
    }
  ])
  formatted_text([
    { text: d("MjAwNC0yMDA1IHw=") },
    {
      text: d("QWRlbGFpZGUsIEF1c3RyYWxpYQ=="),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPTU1K05vcnRoK1RlcnJhY2UsK0FkZWxhaWRlK1NBKz"\
              "UwMDAmc2xsPS0zNC45NjE2OTIsMTM4LjYyMTM5OSZzc3BuPTAuMDU2ODM2LDAuM"\
              "DcxNTgzJnZwc3JjPTYmaWU9VVRGOCZocT0maG5lYXI9NTUrTm9ydGgrVGVycmFj"\
              "ZSwrQWRlbGFpZGUsK1NvdXRoK0F1c3RyYWxpYSs1MDAwJmxsPS0zNC45MjIxODI"\
              "sMTM4LjU5MDg1NiZzcG49MC4wMjg0MzIsMC4wMzU3OTEmdD1tJno9MTUmaXdsb2"\
              "M9QQ==")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([210, cursor], width: 35, height: 40) do
    image open(
      "http://farm4.staticflickr.com/3792/8812488692_96818be468_m.jpg"),
      fit: [35, 40]
    move_up 35
    transparent(0) do
      formatted_text([{
        text: "|||",
        size: 43,
        link: d("aHR0cHM6Ly93d3cudW5pc2EuZWR1LmF1Lw=="),
        align: :center
      }])
    end
  end

################################################################################
### BIB
################################################################################
  move_up 38
  formatted_text_box([
    {
      text: d("QmFjaGVsb3Igb2YgSW50ZXJuYXRpb25hbCBCdXNpbmVzcw=="),
      styles: [:bold]
    }
  ], at: [280, cursor])
  move_down 14
  formatted_text_box([
    {
      text: d("RmxpbmRlcnMgVW5pdmVyc2l0eQ=="),
      styles: [:bold], size: 11
    }
  ], at: [280, cursor])
  move_down 13
  formatted_text_box([
    { text: d("MTk5Ny0xOTk5IHw="), color: "666666", size: 10 },
    {
      text: d("QWRlbGFpZGUsIEF1c3RyYWxpYQ=="),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPVN0dXJ0K1JkLCtCZWRmb3JkK1BhcmsrU0ErNTA0Mi"\
              "ZhcT0mc2xsPS0zNC45MjIxODIsMTM4LjU5MDg1NiZzc3BuPTAuMDI4NDMyLDAuM"\
              "DM1NzkxJnZwc3JjPTYmaWU9VVRGOCZocT0maG5lYXI9U3R1cnQrUmQsK0JlZGZv"\
              "cmQrUGFyaytTb3V0aCtBdXN0cmFsaWErNTA0MiZsbD0tMzUuMDE2NzgyLDEzOC4"\
              "1Njc5ODImc3BuPTAuMDU2Nzk4LDAuMDcxNTgzJnQ9bSZ6PTE0Jml3bG9jPUE="),
      color: "666666", size: 10
    }
  ], at: [280, cursor])

  move_up 30
  bounding_box([490, cursor], width: 35, height: 40) do
    image open(
      "http://farm4.staticflickr.com/3707/8812488974_71c6981155_m.jpg"),
      fit: [35, 40]
    move_up 40
    transparent(0) do
      formatted_text([{
        text: "|||",
        size: 43,
        link: d("aHR0cDovL3d3dy5mbGluZGVycy5lZHUuYXUv"),
        align: :center
      }])
    end
  end

################################################################################
### RYU
################################################################################
 move_down 20
  formatted_text([
    {
      text: d("U3R1ZGVudCBFeGNoYW5nZSBQcm9ncmFtbWU="),
      styles: [:bold]
    }
  ])
  formatted_text([
    {
      text: d("Unl1a29rdSBVbml2ZXJzaXR5"),
      styles: [:bold], size: 11
    }
  ])
  formatted_text([
    { text: d("U2VwIDE5OTkgLSBGZWIgMjAwMCB8") },
    {
      text: d("S3lvdG8sIEphcGFu"),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPSVFNCVCQSVBQyVFOSU4MyVCRCVFNSVCQSU5QyVFNC"\
              "VCQSVBQyVFOSU4MyVCRCVFNSVCOCU4MiVFNCVCQyU4RiVFOCVBNiU4QiVFNSU4Q"\
              "yVCQSVFNiVCNyVCMSVFOCU4RCU4OSVFNSVBMSU5QSVFNiU5QyVBQyVFNyU5NCVC"\
              "QSVFRiVCQyU5NiVFRiVCQyU5NyZhcT0mc2xsPS0zNS4wMTY3ODIsMTM4LjU2Nzk"\
              "4MiZzc3BuPTAuMDU2Nzk4LDAuMDcxNTgzJnZwc3JjPTYmZz1TdHVydCtSZCwrQm"\
              "VkZm9yZCtQYXJrK1NvdXRoK0F1c3RyYWxpYSs1MDQyJmllPVVURjgmaHE9JmhuZ"\
              "WFyPUphcGFuLCtLeSVDNSU4RHRvLWZ1LCtLeSVDNSU4RHRvLXNoaSwrRnVzaGlt"\
              "aS1rdSwrRnVrYWt1c2ErVHN1a2Ftb3RvY2glQzUlOEQsKyVFRiVCQyU5NiVFRiV"\
              "CQyU5NyZsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNwbj0wLjAwNzEwNCwwLjAwOD"\
              "k0OCZ0PW0mej0xNyZpd2xvYz1B")
    }
  ], color: "666666", size: 10)

  move_up 40
  bounding_box([214, cursor], width: 32, height: 40) do
    image open(
      "http://farm8.staticflickr.com/7428/8812488856_c4c1b1f418_m.jpg"),
      fit: [32, 40]
    move_up 40
    transparent(0) do
      formatted_text([{
        text: "|||",
        size: 40,
        link: d("aHR0cDovL3d3dy5yeXVrb2t1LmFjLmpwL2VuZ2xpc2gyL2luZGV4LnBocA=="),
        align: :center
      }])
    end
  end

################################################################################
### TAFE
################################################################################
  move_up 38
  formatted_text_box([
    {
      text: d("Q2VydGlmaWNhdGUgSUkgaW4gVG91cmlzbQ=="),
      styles: [:bold]
    }
  ], at: [280, cursor])
  move_down 14
  formatted_text_box([
    {
      text: d("QWRlbGFpZGUgVEFGRQ=="),
      styles: [:bold], size: 11
    }
  ], at: [280, cursor])
  move_down 13
  formatted_text_box([
    { text: d("TWF5IDIwMDAgLSBNYXkgMjAwMSB8"), color: "666666", size: 10 },
    {
      text: d("QWRlbGFpZGUsIEF1c3RyYWxpYQ=="),
      link: d("aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
              "obD1lbiZnZW9jb2RlPSZxPTEyMCtDdXJyaWUrU3RyZWV0K0FERUxBSURFK1NBKz"\
              "UwMDAmYXE9JnNsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNzcG49MC4wMDcxMDQsM"\
              "C4wMDg5NDgmdnBzcmM9NiZpZT1VVEY4JmhxPSZobmVhcj0xMjArQ3VycmllK1N0"\
              "LCtBZGVsYWlkZStTb3V0aCtBdXN0cmFsaWErNTAwMCZ0PW0mbGw9LTM0LjkyNDU"\
              "0LDEzOC41OTU1MTImc3BuPTAuMDE0MjE1LDAuMDE3ODk2Jno9MTYmaXdsb2M9QQ"\
              "=="),
      color: "666666", size: 10
    }
  ], at: [280, cursor])

  move_up 23
  bounding_box([490, cursor], width: 37, height: 35) do
    image open(
      "http://farm8.staticflickr.com/7377/8812488734_e43ce6742b_m.jpg"),
      fit: [37, 35]
    move_up 19
    transparent(0) do
      formatted_text([{
        text: "|||||",
        size: 28,
        link: d("aHR0cDovL3d3dy50YWZlc2EuZWR1LmF1"),
        align: :center
      }])
    end
  end
end

################################################################################
### Post-document generation handling
################################################################################
puts green "Resume generated successfully."
print yellow "Would you like me to open the resume for you (Y/N)? "
open_document if permission_granted?
puts cyan "Thanks for looking at my resume.  I hope to hear from you soon!"