# encoding: utf-8
DOCUMENT_NAME = "Resume"
################################################################################
### Instructions:
### 1. Make sure you have Ruby 1.9.2 or greater installed (1.8.7 will fail)
### 2. Please let the script install the Prawn gem for PDF generation if you
###    don't have it already.  Otherwise, please contact me for a resume.
### 3. The script will pull down some small images from Flickr, so please ensure
###    you have an internet connection.
### 4. Run the script: $ ruby resume.rb
################################################################################

################################################################################
### Script helper methods
################################################################################
def colorize(text, color_code); "\e[#{color_code}m#{text}\e[0m"; end
def red(text); colorize(text, 31); end
def yellow(text); colorize(text, 33); end
def green(text); colorize(text, 32); end
def cyan(text); colorize(text, 36); end

def yes?(response)
  response =~ %r(\Ay\z|\Ayes\z)i
end

def gem_available?(name)
   Gem::Specification.find_by_name(name)
rescue Gem::LoadError
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
    puts yellow "Sorry, I can't figure out how to open the resume on this"\
                " computer. Please open it yourself."
  end
end

def bullet_list(*items)
  table_data = []
  items.each do |item|
    table_data << ["•", d(item)]
  end
  table(table_data, cell_style: { borders: [] })
end

def social_media_links(cells)
  table_data, images, links = [], [], []
  cells.each do |cell|
    images << { image: open(cell[:image]), scale: 0.7, position: :center,
                padding: cell[:image_padding] || [0, 5, 0, 5] }
    links << { content: d(cell[:link]), align: :center, inline_format: true,
               padding: cell[:link_padding] || [2, 5, 0, 5] }
  end
  table_data << images << links
  table(table_data, cell_style: { borders: [] })
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
unless gem_available?("prawn")
  print yellow "May I please install the 'Prawn' Ruby gem to help me generate "\
               "a PDF (Y/N)? "
  if yes?(gets.chomp)
    puts green "Thank you kindly."
    puts "Installing prawn gem..."
    begin
      %x(gem install prawn -v 1.0.0.rc2)
    rescue
      puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
        "Either try again or ask me directly for a PDF copy of my resume."
      exit
    end
    puts green "Prawn gem successfully installed."
    Gem.clear_paths # Reset the dir and path values so Prawn can be required
  else
    puts red "Sorry, I won't be able to generate a PDF without this gem.\n"\
             "Please ask me directly for a PDF copy of my resume."
    exit
  end
end

################################################################################
### Generate document
################################################################################
require "base64"
require "prawn"
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

  puts "Creating social media links section..."

  move_down 5
  social_media_links([
    {
      image: "http://farm3.staticflickr.com/2826/8753727736_2a7a294527_m.jpg",
      image_padding: [0, 5, 0, 0],
      link: "PGNvbG9yIHJnYj0nMTMxMzEzJz48YSBocmVmPSdtYWlsdG86cGF1bC5maW9yYXZh"\
            "bnRpQGdtYWlsLmNvbSc+PHU+RW1haWw8L3U+PC9hPjwvY29sb3I+",
      link_padding: [2, 5, 0, 0]
    },
    {
      image: "http://farm4.staticflickr.com/3687/8809717292_4938937a94_m.jpg",
      link: "PGNvbG9yIHJnYj0nMTI0OTkyJz48YSBocmVmPSdodHRwOi8vbGlua2VkaW4uY29t"\
            "L2luL3BhdWxmaW9yYXZhbnRpJz48dT5MaW5rZWRJbjwvdT48L2E+PC9jb2xvcj4="
    },
    {
      image: "http://farm4.staticflickr.com/3828/8799239149_d23e4acff0_m.jpg",
      link: "PGNvbG9yIHJnYj0nM0MzQzNDJz48YSBocmVmPSdodHRwOi8vZ2l0aHViLmNvbS9w"\
            "YXVsZmlvcmF2YW50aSc+PHU+R2l0aHViPC91PjwvYT48L2NvbG9yPg=="
    },
    {
      image: "http://farm3.staticflickr.com/2815/8799253647_e4ec3ab1bc_m.jpg",
      link: "PGNvbG9yIHJnYj0nRjM2ODExJz48YSBocmVmPSdodHRwOi8vc3RhY2tvdmVyZmxv"\
            "dy5jb20vdXNlcnMvNTY3ODYzL3BhdWwtZmlvcmF2YW50aSc+PHU+U3RhY2tPdmVy"\
            "ZmxvdzwvdT48L2E+PC9jb2xvcj4="
    },
    {
      image: "http://farm3.staticflickr.com/2837/8799235993_26a7d17540_m.jpg",
      link: "PGNvbG9yIHJnYj0nMjM4NkUxJz48YSBocmVmPSdodHRwczovL3R3aXR0ZXIuY29t"\
            "L3BlZmlvcmF2YW50aSc+PHU+VHdpdHRlcjwvdT48L2E+PC9jb2xvcj4="
    },
    {
      image: "http://farm8.staticflickr.com/7404/8799250189_4125b90a14_m.jpg",
      link: "PGNvbG9yIHJnYj0nMUM0ODM4Jz48YSBocmVmPSdodHRwczovL3NwZWFrZXJkZWNr"\
            "LmNvbS9wYXVsZmlvcmF2YW50aSc+PHU+U3BlYWtlckRlY2s8L3U+PC9hPjwvY29s"\
            "b3I+"
    },
    {
      image: "http://farm9.staticflickr.com/8546/8809862216_0cdd40c3dc_m.jpg",
      link: "PGNvbG9yIHJnYj0nMjU4N0JBJz48YSBocmVmPSdodHRwczovL3ZpbWVvLmNvbS9w"\
            "YXVsZmlvcmF2YW50aSc+PHU+VmltZW88L3U+PC9hPjwvY29sb3I+"
    },
    {
      image: "http://farm4.staticflickr.com/3752/8809826162_e4d765d15b_m.jpg",
      image_padding: [0, 0, 0, 5],
      link: "PGNvbG9yIHJnYj0nNDYzOTI3Jz48YSBocmVmPSdodHRwOi8vcGF1bGZpb3JhdmFu"\
            "dGkuY29tL2Fib3V0Jz48dT5CbG9nPC91PjwvYT48L2NvbG9yPg==",
      link_padding: [2, 0, 0, 5]
    }
  ])

  pad(10) { stroke_horizontal_rule { color "666666" } }

  puts "Creating employment history section..."

  heading "RW1wbG95bWVudCBIaXN0b3J5"

  ruby_table_data = [
    [
      {
        content: d("PGI+UnVieSBEZXZlbG9wZXI8L2I+Cjxmb250IHNpemU9JzExJz48Yj5Gc"\
          "mVlbGFuY2U8L2I+PC9mb250Pgo8Zm9udCBzaXplPScxMCc+PGNvbG9yIHJnYj0nNjY"\
          "2NjY2Jz5TZXB0ZW1iZXIgMjAxMiDigJMgUHJlc2VudCB8IDxhIGhyZWY9J2h0dHBzO"\
          "i8vbWFwcy5nb29nbGUuY29tL21hcHM/Zj1xJnNvdXJjZT1zX3EmaGw9ZW4mZ2VvY29"\
          "kZT0mcT1hZGVsYWlkZSwrYXVzdHJhbGlhJmFxPSZzbGw9LTM0Ljk2MTY5MiwxMzguN"\
          "jIxMzk5JnNzcG49MC4wNTY4MzYsMC4wNzE1ODMmdnBzcmM9NCZpZT1VVEY4JmhxPSZ"\
          "obmVhcj1BZGVsYWlkZStTb3V0aCtBdXN0cmFsaWEsK0F1c3RyYWxpYSZ0PW0mej05J"\
          "ml3bG9jPUEnPiBBZGVsYWlkZSwgQXVzdHJhbGlhPC9hPjwvY29sb3I+PC9mb250Pg="\
          "="),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0], width: 430
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3793/8799953079_33cfdc0def_m.jpg"),
        scale: 0.7, padding: [5, 5, 0, 0], position: :right
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3681/8810534562_dfc34ea70c_m.jpg"),
        scale: 0.7, padding: [5, 5, 0, 5], position: :left
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9Jzg1MjAwQyc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5ydWJ5LWxhbmcub3JnL2VuLyc+PHU+UnVieTwvdT48L2E+PC9"\
          "jb2xvcj48L2ZvbnQ+"),
        inline_format: true, align: :right, padding: [0, 5, 0, 5]
      },
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9Jzg1MjAwQyc+PGEgaHJlZ"\
          "j0naHR0cDovL3J1YnlvbnJhaWxzLm9yZy8nJz48dT5SYWlsczwvdT48L2E+PC9jb2x"\
          "vcj48L2ZvbnQ+"),
        inline_format: true, align: :left, padding: [0, 5, 0, 5]
      }
    ]
  ]
  table(ruby_table_data, cell_style: { borders: [] })

  move_down 10
  text d "UHJvamVjdCBhbmQgc2hvcnQtdGVybSBjb250cmFjdCB3b3JrIHdpdGggQWRlbGFp"\
         "ZGUgc3RhcnQtdXAgY29tcGFuaWVzIHVzaW5nIFJ1Ynkgb24gUmFpbHMsIHByaW1h"\
         "cmlseSByZW1vdGVseSBvciBpbiBjb3dvcmtpbmcgc3BhY2VzLg=="

  move_down 10
  gw_table_data = [
    [
      {
        content: d("PGI+UHJlLXNhbGVzIENvbnN1bHRhbnQ8L2I+Cjxmb250IHNpemU9JzExJ"\
          "z48Yj5HdWlkZXdpcmUgU29mdHdhcmU8L2I+PC9mb250Pgo8Zm9udCBzaXplPScxMCc"\
          "+PGNvbG9yIHJnYj0nNjY2NjY2Jz5KYW51YXJ5IDIwMDkg4oCTIFNlcHRlbWJlciAyM"\
          "DExIHwgPGEgaHJlZj0naHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20vbWFwcz9mPXEmc29"\
          "1cmNlPXNfcSZobD1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjEwMC0wMDA2KyslRTYlO"\
          "UQlQjElRTQlQkElQUMlRTklODMlQkQlRTUlOEQlODMlRTQlQkIlQTMlRTclOTQlQjA"\
          "lRTUlOEMlQkElRTYlOUMlODklRTYlQTUlQkQlRTclOTQlQkEyLTctMSsrJUU2JTlDJ"\
          "Tg5JUU2JUE1JUJEJUU3JTk0JUJBJUUzJTgyJUE0JUUzJTgzJTg4JUUzJTgyJUI3JUU"\
          "zJTgyJUEyKzEyJUU5JTlBJThFJmFxPSZzbGw9LTM0LjkyODYyMSwxMzguNTk5OTU5J"\
          "nNzcG49MS44MTk0MzYsMi4yOTA2NDkmdnBzcmM9MCZnPWFkZWxhaWRlLCthdXN0cmF"\
          "saWEmaWU9VVRGOCZocT0lRTMlODAlOTIxMDAtMDAwNisrJUU2JTlEJUIxJUU0JUJBJ"\
          "UFDJUU5JTgzJUJEJUU1JThEJTgzJUU0JUJCJUEzJUU3JTk0JUIwJUU1JThDJUJBJUU"\
          "2JTlDJTg5JUU2JUE1JUJEJUU3JTk0JUJBMi03LTErKyVFNiU5QyU4OSVFNiVBNSVCR"\
          "CVFNyU5NCVCQSVFMyU4MiVBNCVFMyU4MyU4OCVFMyU4MiVCNyVFMyU4MiVBMisxMiV"\
          "FOSU5QSU4RSZ0PW0mej0xNSZpd2xvYz1BJmNpZD0xNzQ4MjYwNDQzMTMwNjkxMzEzM"\
          "yc+IFRva3lvLCBKYXBhbjwvYT48L2NvbG9yPjwvZm9udD4="),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0]
      },
      {
        image: open(
          "http://farm8.staticflickr.com/7376/8812488914_f0bfd0a841_m.jpg"),
        scale: 0.7, padding: [5, 5, 0, 0], position: :center
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzFDNUJBNCc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5ndWlkZXdpcmUuY29tLyc+PHU+R3VpZGV3aXJlIFNvZnR3YXJ"\
          "lPC91PjwvYT48L2NvbG9yPjwvZm9udD4="),
        inline_format: true, align: :center, padding: [0, 5, 0, 5], width: 150
      }
    ]
  ]
  table(gw_table_data, cell_style: { borders: [] })

  move_down 10
  text d "Q29tcGxleCBzYWxlcyBvZiBHdWlkZXdpcmUgQ2xhaW1DZW50ZXIgaW5zdXJhbmNlI"\
         "GNsYWltIGhhbmRsaW5nIHN5c3RlbSB0byBidXNpbmVzcyBhbmQgSVQgZGVwYXJ0bW"\
         "VudHMgb2YgUHJvcGVydHkgJiBDYXN1YWx0eSBpbnN1cmFuY2UgY29tcGFuaWVzLiA"\
         "gUmVzcG9uc2liaWxpdGllcyBpbmNsdWRlZDo="

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

  move_down 10
  rnt_table_data = [
    [
      {
        content: d("PGI+SW1wbGVtZW50YXRpb24gQ29uc3VsdGFudCwgUHJvZmVzc2lvbmFsI"\
          "FNlcnZpY2VzPC9iPgo8Zm9udCBzaXplPScxMSc+PGI+UmlnaHQgTm93IFRlY2hub2x"\
          "vZ2llczwvYj48L2ZvbnQ+Cjxmb250IHNpemU9JzEwJz48Y29sb3IgcmdiPSc2NjY2N"\
          "jYnPkp1bHkgMjAwNyDigJMgQXVndXN0IDIwMDggfCA8YSBocmVmPSdodHRwczovL21"\
          "hcHMuZ29vZ2xlLmNvbS9tYXBzP2Y9cSZzb3VyY2U9c19xJmhsPWVuJmdlb2NvZGU9J"\
          "nE9JUUzJTgwJTkyMTA1LTYwMjclRTYlOUQlQjElRTQlQkElQUMlRTklODMlQkQlRTY"\
          "lQjglQUYlRTUlOEMlQkElRTglOTklOEUlRTMlODMlOEUlRTklOTYlODA0LTMtMSslR"\
          "TUlOUYlOEUlRTUlQjElQjElRTMlODMlODglRTMlODMlQTklRTMlODIlQjklRTMlODM"\
          "lODglRTMlODIlQkYlRTMlODMlQUYlRTMlODMlQkMrMjclRTklOUElOEUmYXE9JnNsb"\
          "D0zNS42NjQ2ODgsMTM5Ljc0MzMwNCZzc3BuPTAuMDI4MTcyLDAuMDM1NzkxJnZwc3J"\
          "jPTYmaWU9VVRGOCZocT0maG5lYXI9SmFwYW4sK1QlQzUlOERreSVDNSU4RC10bywrT"\
          "WluYXRvLWt1LCtUb3Jhbm9tb24sKyVFRiVCQyU5NCVFNCVCOCU4MSVFNyU5QiVBRSV"\
          "FRiVCQyU5MyVFMiU4OCU5MiVFRiVCQyU5MSslRTUlOUYlOEUlRTUlQjElQjElRTMlO"\
          "DMlODglRTMlODMlQTklRTMlODIlQjklRTMlODMlODglRTMlODIlQkYlRTMlODMlQUY"\
          "lRTMlODMlQkMmbGw9MzUuNjY0Njg4LDEzOS43NDMyNjEmc3BuPTAuMDI4MTcyLDAuM"\
          "DM1NzkxJnQ9bSZ6PTE1Jml3bG9jPUEnPiBUb2t5bywgSmFwYW48L2E+PC9jb2xvcj4"\
          "8L2ZvbnQ+"),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0]
      },
      {
        image: open(
          "http://farm8.staticflickr.com/7326/8801904137_e6008ee907_m.jpg"),
        scale: 0.65, padding: [0, 5, 0, 0], position: :center
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzM2NTE2RCc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5vcmFjbGUuY29tL3VzL3Byb2R1Y3RzL2FwcGxpY2F0aW9ucy9"\
          "yaWdodG5vdy9vdmVydmlldy9pbmRleC5odG1sJz48dT5SaWdodCBOb3cgVGVjaG5vb"\
          "G9naWVzPC91PjwvYT48L2NvbG9yPjwvZm9udD4="),
        inline_format: true, align: :center, padding: [0, 5, 0, 5], width: 150
      }
    ]
  ]
  table(rnt_table_data, cell_style: { borders: [] })

  move_down 10
  text d "T24gYW5kIG9mZi1zaXRlIGN1c3RvbWVyIGltcGxlbWVudGF0aW9ucyBvZiBSaWdodCBO"\
         "b3cgQ2xvdWQgQ1JNIHByb2R1Y3QuICBSZXNwb25zaWJpbGl0aWVzIGluY2x1ZGVkOg=="

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

  move_down 10
  sra_table_data = [
    [
      {
        content: d("PGI+U29mdHdhcmUgRW5naW5lZXI8L2I+Cjxmb250IHNpemU9JzExJz48Y"\
          "j5Tb2Z0d2FyZSBSZXNlYXJjaCBBc3NvY2lhdGVzIChTUkEpPC9iPjwvZm9udD4KPGZ"\
          "vbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzY2NjY2Nic+QXByaWwgMjAwNiDigJMgS"\
          "nVuZSAyMDA3IHwgPGEgaHJlZj0naHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWF"\
          "wcz9mPXEmc291cmNlPXNfcSZobD1lbiZnZW9jb2RlPSZxPSVFMyU4MCU5MjE3MS04N"\
          "TEzJUU2JTlEJUIxJUU0JUJBJUFDJUU5JTgzJUJEJUU4JUIxJThBJUU1JUIzJUI2JUU"\
          "1JThDJUJBJUU1JThEJTk3JUU2JUIxJUEwJUU4JUEyJThCMi0zMi04JmFxPSZzbGw9M"\
          "zUuNzI2NjAxLDEzOS43MTU1MDgmc3Nwbj0wLjAwNzAzOCwwLjAwODk0OCZ2cHNyYz0"\
          "wJmllPVVURjgmaHE9JmhuZWFyPUphcGFuLCtUJUM1JThEa3klQzUlOEQtdG8sK1Rvc"\
          "2hpbWEta3UsK01pbmFtaWlrZWJ1a3VybywrJUVGJUJDJTkyJUU0JUI4JTgxJUU3JTl"\
          "CJUFFJUVGJUJDJTkzJUVGJUJDJTkyJUUyJTg4JTkyJUVGJUJDJTk4JnQ9bSZ6PTE3J"\
          "ml3bG9jPUEnPiBUb2t5bywgSmFwYW48L2E+PC9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0]
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3801/8801903945_723a5d7276_m.jpg"),
        scale: 0.55, padding: [5, 5, 0, 0], position: :center
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzJGNDY4Qyc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5zcmEuY28uanAvaW5kZXgtZW4uc2h0bWwnPjx1PlNvZnR3YXJ"\
          "lIFJlc2VhcmNoIEFzc29jaWF0ZXM8L3U+PC9hPjwvY29sb3I+PC9mb250Pg=="),
        inline_format: true, align: :center, padding: [0, 5, 0, 5], width: 150
      }
    ]
  ]
  table(sra_table_data, cell_style: { borders: [] })

  move_down 10
  text d "Q3VzdG9tIHNvZnR3YXJlIGRldmVsb3BtZW50IGluIHNtYWxsIHRlYW1zOyBkZXNpZ24"\
         "sIGNvZGluZywgdGVzdGluZywgZG9jdW1lbnRhdGlvbiwgZGVwbG95bWVudDsgaW50ZX"\
         "JuYWwgc3lzdGVtIGFkbWluaXN0cmF0aW9uIGR1dGllcy4gIERldmVsb3BtZW50IHByZ"\
         "WRvbWluYW50bHkgZG9uZSB1c2luZyBQdXJlIFJ1YnkvUnVieSBvbiBSYWlscyBpbiBz"\
         "bWFsbCB0ZWFtcyBvZiAyLTMgcGVvcGxlLg=="

  move_down 10
  jet_table_data = [
    [
      {
        content: d("PGI+Q29vcmRpbmF0b3Igb2YgSW50ZXJuYXRpb25hbCBSZWxhdGlvbnMgK"\
          "ENJUik8L2I+Cjxmb250IHNpemU9JzExJz48Yj5KYXBhbiBFeGNoYW5nZSBhbmQgVGV"\
          "hY2hpbmcgUHJvZ3JhbW1lIChKRVQpPC9iPjwvZm9udD4KPGZvbnQgc2l6ZT0nMTAnP"\
          "jxjb2xvciByZ2I9JzY2NjY2Nic+SnVseSAyMDAxIOKAkyBKdWx5IDIwMDQgfCA8YSB"\
          "ocmVmPSdodHRwczovL21hcHMuZ29vZ2xlLmNvbS5hdS9tYXBzP2Y9cSZzb3VyY2U9c"\
          "19xJmhsPWVuJmdlb2NvZGU9JnE9JUUzJTgwJTkyNzgwLTA4NTAlRTklQUIlOTglRTc"\
          "lOUYlQTUlRTUlQjglODIlRTQlQjglQjglRTMlODMlOEUlRTUlODYlODUxJUU0JUI4J"\
          "TgxJUU3JTlCJUFFNyVFNyU5NSVBQTUyJUU1JThGJUI3JmFxPSZzbGw9LTM0Ljk2MTY"\
          "5MiwxMzguNjIxMzk5JnNzcG49MC4wNTY4MzYsMC4wNzE1ODMmdnBzcmM9NiZpZT1VV"\
          "EY4JmhxPSZobmVhcj1KYXBhbiwrSyVDNSU4RGNoaS1rZW4sK0slQzUlOERjaGktc2h"\
          "pLCtNYXJ1bm91Y2hpLCslRUYlQkMlOTElRTQlQjglODElRTclOUIlQUUlRUYlQkMlO"\
          "TclRTIlODglOTIlRUYlQkMlOTUlRUYlQkMlOTImbGw9MzMuNTU5NDU2LDEzMy41Mjg"\
          "zMDQmc3BuPTAuMDE0NDQ4LDAuMDE3ODk2JnQ9bSZ6PTE2Jml3bG9jPUEnPiBLb2Noa"\
          "SwgSmFwYW48L2E+PC9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0]
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3690/8801904135_37197a468c_m.jpg"),
        scale: 0.55, padding: [5, 5, 0, 0], position: :center
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzAwMDA4Nic+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5qZXRwcm9ncmFtbWUub3JnL2UvYXNwaXJpbmcvcG9zaXRpb25"\
          "zLmh0bWwnPjx1PkpFVCBQcm9ncmFtbWU8L3U+PC9hPjwvY29sb3I+PC9mb250Pg=="),
        inline_format: true, align: :center, padding: [0, 5, 0, 5], width: 150
      }
    ]
  ]

  table(jet_table_data, cell_style: { borders: [] })

  move_down 10
  text d "VHJhbnNsYXRpb247IGludGVycHJldGluZzsgZWRpdG9yaWFsIHN1cGVydmlzaW9uIG9"\
         "mIGJpbGluZ3VhbCBwYW1waGxldHM7IHJlY2VwdGlvbiBvZiBmb3JlaWduIGd1ZXN0cz"\
         "sgcGxhbm5pbmcgYW5kIGltcGxlbWVudGluZyBpbnRlcm5hdGlvbmFsIGV4Y2hhbmdlI"\
         "HByb2plY3RzOyBhY2NvbXBhbnlpbmcgdG91ciBncm91cHMgb3ZlcnNlYXM7IHdvcmsg"\
         "d2l0aCBub24tcHJvZml0IG9yZ2FuaXphdGlvbnM="

  move_down 10
  satc_table_data = [
    [
      {
        content: d("PGI+SW50ZXJuYXRpb25hbCBNYXJrZXRpbmcgQXNzaXN0YW50IOKAkyBBc"\
          "2lhIGFuZCBKYXBhbjwvYj4KPGZvbnQgc2l6ZT0nMTEnPjxiPlNvdXRoIEF1c3RyYWx"\
          "pYW4gVG91cmlzbSBDb21taXNzaW9uIChTQVRDKTwvYj48L2ZvbnQ+Cjxmb250IHNpe"\
          "mU9JzEwJz48Y29sb3IgcmdiPSc2NjY2NjYnPk1heSAyMDAwIOKAkyBNYXkgMjAwMSB"\
          "8IDxhIGhyZWY9J2h0dHBzOi8vbWFwcy5nb29nbGUuY29tLmF1L21hcHM/Zj1xJnNvd"\
          "XJjZT1zX3EmaGw9ZW4mZ2VvY29kZT0mcT01MCtHcmVuZmVsbCtTdCwrQWRlbGFpZGU"\
          "rU0EmYXE9JnNsbD0tMzQuOTI0MjIzLDEzOC42MDE3MTMmc3Nwbj0wLjA1NzE0MywwL"\
          "jA3MTU4MyZ2cHNyYz02Jmc9NTArR3JlbmZlbGwrU3QsK0FkZWxhaWRlK1NBJmllPVV"\
          "URjgmaHE9JmhuZWFyPTUwK0dyZW5mZWxsK1N0LCtBZGVsYWlkZStTb3V0aCtBdXN0c"\
          "mFsaWErNTAwMCZsbD0tMzQuOTI0MDgyLDEzOC42MDE2OTImc3BuPTAuMDE0MjE1LDA"\
          "uMDE3ODk2JnQ9bSZ6PTE2Jml3bG9jPUEnPkFkZWxhaWRlLCBBdXN0cmFsaWE8L2E+P"\
          "C9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0]
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3804/8801903991_103f5a47f8_m.jpg"),
        scale: 0.65, padding: [0, 5, 0, 0], position: :center
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzlFOUU5RSc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5zb3V0aGF1c3RyYWxpYS5jb20vJz48dT5TQVRDPC91PjwvYT4"\
          "8L2NvbG9yPjwvZm9udD4="),
        inline_format: true, align: :center, padding: [0, 5, 0, 5], width: 150
      }
    ]
  ]
  table(satc_table_data, cell_style: { borders: [] })

  move_down 10
  text d "UHJvY2VzcyB0cmFkZSBlbnF1aXJpZXMgZnJvbSBBc2lhIGFuZCBKYXBhbjsgYXNzaXN"\
         "0IG9wZXJhdG9ycyBvZiB0b3VyaXNtIHByb2R1Y3RzIGluIFNvdXRoIEF1c3RyYWxpYS"\
         "B3aXRoIEphcGFuL0FzaWEgbWFya2V0aW5nOyBhc3Npc3Rpbmcgd2l0aCB0cmFkZSBza"\
         "G93cywgdGhlIHNvdXJjaW5nIG9mIHN1aXRhYmxlIHByb21vdGlvbmFsIGl0ZW1zIGZv"\
         "ciBjYW1wYWlnbnMsIGFuZCBtYXJrZXRpbmcgcmVzZWFyY2g="

  move_down 10
  stroke_horizontal_rule { color "666666" }

  puts "Creating education section..."

  move_down 10
  heading "RWR1Y2F0aW9u"

  edu_table_data = [
    [
      {
        content: d("PGI+TWFzdGVycyBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5PC9iPgo8Z"\
          "m9udCBzaXplPScxMSc+PGI+VW5pdmVyc2l0eSBvZiBTb3V0aCBBdXN0cmFsaWE8L2I"\
          "+PC9mb250Pgo8Zm9udCBzaXplPScxMCc+PGNvbG9yIHJnYj0nNjY2NjY2Jz4yMDA0L"\
          "TIwMDUgfCA8YSBocmVmPSdodHRwczovL21hcHMuZ29vZ2xlLmNvbS5hdS9tYXBzP2Y"\
          "9cSZzb3VyY2U9c19xJmhsPWVuJmdlb2NvZGU9JnE9NTUrTm9ydGgrVGVycmFjZSwrQ"\
          "WRlbGFpZGUrU0ErNTAwMCZzbGw9LTM0Ljk2MTY5MiwxMzguNjIxMzk5JnNzcG49MC4"\
          "wNTY4MzYsMC4wNzE1ODMmdnBzcmM9NiZpZT1VVEY4JmhxPSZobmVhcj01NStOb3J0a"\
          "CtUZXJyYWNlLCtBZGVsYWlkZSwrU291dGgrQXVzdHJhbGlhKzUwMDAmbGw9LTM0Ljk"\
          "yMjE4MiwxMzguNTkwODU2JnNwbj0wLjAyODQzMiwwLjAzNTc5MSZ0PW0mej0xNSZpd"\
          "2xvYz1BJz5BZGVsYWlkZSwgQXVzdHJhbGlhPC9hPjwvY29sb3I+PC9mb250Pg=="),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0], width: 210
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3792/8812488692_96818be468_m.jpg"),
        scale: 0.55, padding: [5, 0, 0, 0], position: :center
      },
      {
        content: d("PGI+QmFjaGVsb3Igb2YgSW50ZXJuYXRpb25hbCBCdXNpbmVzczwvYj4KP"\
          "GZvbnQgc2l6ZT0nMTEnPjxiPkZsaW5kZXJzIFVuaXZlcnNpdHk8L2I+PC9mb250Pgo"\
          "8Zm9udCBzaXplPScxMCc+PGNvbG9yIHJnYj0nNjY2NjY2Jz4xOTk3LTE5OTkgfCA8Y"\
          "SBocmVmPSdodHRwczovL21hcHMuZ29vZ2xlLmNvbS5hdS9tYXBzP2Y9cSZzb3VyY2U"\
          "9c19xJmhsPWVuJmdlb2NvZGU9JnE9U3R1cnQrUmQsK0JlZGZvcmQrUGFyaytTQSs1M"\
          "DQyJmFxPSZzbGw9LTM0LjkyMjE4MiwxMzguNTkwODU2JnNzcG49MC4wMjg0MzIsMC4"\
          "wMzU3OTEmdnBzcmM9NiZpZT1VVEY4JmhxPSZobmVhcj1TdHVydCtSZCwrQmVkZm9yZ"\
          "CtQYXJrK1NvdXRoK0F1c3RyYWxpYSs1MDQyJmxsPS0zNS4wMTY3ODIsMTM4LjU2Nzk"\
          "4MiZzcG49MC4wNTY3OTgsMC4wNzE1ODMmdD1tJno9MTQmaXdsb2M9QSc+IEFkZWxha"\
          "WRlLCBBdXN0cmFsaWE8L2E+PC9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 30]
      },
      {
        image: open(
          "http://farm4.staticflickr.com/3707/8812488974_71c6981155_m.jpg"),
        scale: 0.60, padding: [3, 0, 0, 0], position: :center
      },
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0iMTAiPjxjb2xvciByZ2I9IjAyMjA4NyI+ICAgICAgI"\
          "CAgICAgICAgICAgICAgICAgPGEgaHJlZj0iaHR0cHM6Ly93d3cudW5pc2EuZWR1LmF"\
          "1LyI+PHU+VW5pU0E8L3U+PC9hPiAgICAgICAgICAgICAgICAgICAgICAgIDwvY29sb"\
          "3I+PC9mb250Pg=="),
        inline_format: true, align: :center, padding: [0, 0, 0, 0], width: 50
      },
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzBGMUQ0Qyc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5mbGluZGVycy5lZHUuYXUvJz48dT5GbGluZGVyczwvdT48L2E"\
          "+PC9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, align: :center, padding: [0, 0, 0, 0], width: 45
      }
    ],
    [
      {
        content: d("PGI+U3R1ZGVudCBFeGNoYW5nZSBQcm9ncmFtbWU8L2I+Cjxmb250IHNpe"\
          "mU9JzExJz48Yj5SeXVrb2t1IFVuaXZlcnNpdHk8L2I+PC9mb250Pgo8Zm9udCBzaXp"\
          "lPScxMCc+PGNvbG9yIHJnYj0nNjY2NjY2Jz5TZXAgMTk5OSAtIEZlYiAyMDAwIHwgP"\
          "GEgaHJlZj0naHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmN"\
          "lPXNfcSZobD1lbiZnZW9jb2RlPSZxPSVFNCVCQSVBQyVFOSU4MyVCRCVFNSVCQSU5Q"\
          "yVFNCVCQSVBQyVFOSU4MyVCRCVFNSVCOCU4MiVFNCVCQyU4RiVFOCVBNiU4QiVFNSU"\
          "4QyVCQSVFNiVCNyVCMSVFOCU4RCU4OSVFNSVBMSU5QSVFNiU5QyVBQyVFNyU5NCVCQ"\
          "SVFRiVCQyU5NiVFRiVCQyU5NyZhcT0mc2xsPS0zNS4wMTY3ODIsMTM4LjU2Nzk4MiZ"\
          "zc3BuPTAuMDU2Nzk4LDAuMDcxNTgzJnZwc3JjPTYmZz1TdHVydCtSZCwrQmVkZm9yZ"\
          "CtQYXJrK1NvdXRoK0F1c3RyYWxpYSs1MDQyJmllPVVURjgmaHE9JmhuZWFyPUphcGF"\
          "uLCtLeSVDNSU4RHRvLWZ1LCtLeSVDNSU4RHRvLXNoaSwrRnVzaGltaS1rdSwrRnVrY"\
          "Wt1c2ErVHN1a2Ftb3RvY2glQzUlOEQsKyVFRiVCQyU5NiVFRiVCQyU5NyZsbD0zNC4"\
          "5NjM5NzQsMTM1Ljc2Nzk3JnNwbj0wLjAwNzEwNCwwLjAwODk0OCZ0PW0mej0xNyZpd"\
          "2xvYz1BJz5LeW90bywgSmFwYW48L2E+PC9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 0], width: 210
      },
      {
        image: open(
          "http://farm8.staticflickr.com/7428/8812488856_c4c1b1f418_m.jpg"),
        scale: 0.55, padding: [5, 0, 0, 0], position: :center
      },
      {
        content: d("PGI+Q2VydGlmaWNhdGUgSUkgaW4gVG91cmlzbTwvYj4KPGZvbnQgc2l6Z"\
          "T0nMTEnPjxiPkFkZWxhaWRlIFRBRkU8L2I+PC9mb250Pgo8Zm9udCBzaXplPScxMCc"\
          "+PGNvbG9yIHJnYj0nNjY2NjY2Jz5NYXkgMjAwMCAtIE1heSAyMDAxIHwgPGEgaHJlZ"\
          "j0naHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfcSZ"\
          "obD1lbiZnZW9jb2RlPSZxPTEyMCtDdXJyaWUrU3RyZWV0K0FERUxBSURFK1NBKzUwM"\
          "DAmYXE9JnNsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNzcG49MC4wMDcxMDQsMC4wMDg"\
          "5NDgmdnBzcmM9NiZpZT1VVEY4JmhxPSZobmVhcj0xMjArQ3VycmllK1N0LCtBZGVsY"\
          "WlkZStTb3V0aCtBdXN0cmFsaWErNTAwMCZ0PW0mbGw9LTM0LjkyNDU0LDEzOC41OTU"\
          "1MTImc3BuPTAuMDE0MjE1LDAuMDE3ODk2Jno9MTYmaXdsb2M9QSc+QWRlbGFpZGUsI"\
          "EF1c3RyYWxpYTwvYT48L2NvbG9yPjwvZm9udD4="),
        inline_format: true, rowspan: 2, padding: [5, 5, 0, 30]
      },
      {
        image: open(
          "http://farm8.staticflickr.com/7377/8812488734_e43ce6742b_m.jpg"),
        scale: 0.60, padding: [7, 0, 0, 0], position: :center
      }
    ],
    [
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9JzdDMEUxNSc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy5yeXVrb2t1LmFjLmpwL2VuZ2xpc2gyL2luZGV4LnBocCc+PHU"\
          "+Unl1a29rdTwvdT48L2E+PC9jb2xvcj48L2ZvbnQ+"),
        inline_format: true, align: :center, padding: [0, 0, 0, 0], width: 50
      },
      {
        content: d("PGZvbnQgc2l6ZT0nMTAnPjxjb2xvciByZ2I9J0RCMDIyNCc+PGEgaHJlZ"\
          "j0naHR0cDovL3d3dy50YWZlc2EuZWR1LmF1Lyc+PHU+VEFGRTwvdT48L2E+PC9jb2x"\
          "vcj48L2ZvbnQ+"),
        inline_format: true, align: :center, padding: [0, 0, 0, 0], width: 45
      }
    ],
  ]
  table(edu_table_data, cell_style: { borders: [] })
end

################################################################################
### Post-document generation handling
################################################################################
puts green "Resume generated successfully."
print yellow "Would you like me to open the resume for you (Y/N)? "
open_document if yes?(gets.chomp)
puts cyan "Thanks for looking at my resume.  I hope to hear from you soon!"