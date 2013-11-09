# encoding: utf-8
require 'base64'
require 'open-uri'

################################################################################
### This resume also lives online in a more componentised format at
### https://github.com/paulfioravanti/resume
### Instructions:
### 1. Make sure you run this with Ruby 1.9.2 or greater (1.8.7 will not work)
### 2. Please let the script install the Prawn gem for PDF generation if you
###    don't have it already.  Otherwise, contact me for a dead tree resume.
### 3. The script will pull down some small images from Flickr, so please ensure
###    you have an internet connection.
### 4. Run the script: $ ruby resume.rb
################################################################################
module ResumeGenerator
  VERSION = '0.0.1'
  DOCUMENT_NAME = 'Resume'

  module Colourable
    private

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
  end

  class CLI
    include Colourable

    def self.report(string)
      puts string
    end

    def start
      check_ability_to_generate_resume
      generate_resume
      clean_up
    end

    private

    def check_ability_to_generate_resume
      return if required_gem_available?('prawn', '1.0.0.rc2')
      print yellow "May I please install version 1.0.0.rc2 of the 'Prawn'\n"\
                   "Ruby gem to help me generate a PDF (Y/N)? "
      if permission_granted?
        install_gem
      else
        puts red "Sorry, I won't be able to generate a PDF without this\n"\
                 "specific version of the Prawn gem.\n"\
                 "Please ask me directly for a PDF copy of my resume."
        exit
      end
    end

    def generate_resume
      require 'prawn'
      Resume.generate
    end

    def clean_up
      puts green 'Resume generated successfully.'
      print yellow 'Would you like me to open the resume for you (Y/N)? '
      open_document if permission_granted?
      puts cyan "Thanks for looking at my resume. "\
                "I hope to hear from you soon!"
    end

    def open_document
      case RUBY_PLATFORM
      when %r(darwin)
        system("open #{DOCUMENT_NAME}.pdf")
      when %r(linux)
        system("xdg-open #{DOCUMENT_NAME}.pdf")
      when %r(windows)
        system("cmd /c \"start #{DOCUMENT_NAME}.pdf\"")
      else
        puts yellow "Sorry, I can't figure out how to open the resume on\n"\
                    "this computer. Please open it yourself."
      end
    end

    def required_gem_available?(name, version)
      Gem::Specification.find_by_name(name).version >= Gem::Version.new(version)
    rescue Gem::LoadError # gem not installed
      false
    end

    def permission_granted?
      gets.chomp.match(%r{\A(y|yes)\z}i)
    end

    def install_gem
      puts green 'Thank you kindly :-)'
      puts 'Installing Prawn gem version 1.0.0.rc2...'
      begin
        system('gem install prawn -v 1.0.0.rc2')
        puts green 'Prawn gem successfully installed.'
        Gem.clear_paths # Reset the dir and path values so Prawn can be required
      rescue
        puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
                 "Either try again or ask me directly for a PDF copy of "\
                 "my resume."
        exit
      end
    end
  end

  module Decodable
    def d(string) # decode string
      Base64.strict_decode64(string)
    end
  end

  class Link
    extend Decodable

    def self.for(resource)
      send(:"#{resource}")
    end

    def self.email
      d('bWFpbHRvOnBhdWwuZmlvcmF2YW50aUBnbWFpbC5jb20=')
    end
    private_class_method :email

    def self.linked_in
      d('aHR0cDovL2xpbmtlZGluLmNvbS9pbi9wYXVsZmlvcmF2YW50aQ==')
    end
    private_class_method :linked_in

    def self.github
      d('aHR0cDovL2dpdGh1Yi5jb20vcGF1bGZpb3JhdmFudGk=')
    end
    private_class_method :github

    def self.stackoverflow
      d("aHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3VzZXJzLzU2Nzg2My9wYXVsLWZpb3Jh"\
        "dmFudGk=")
    end
    private_class_method :stackoverflow

    def self.speakerdeck
      d('aHR0cHM6Ly9zcGVha2VyZGVjay5jb20vcGF1bGZpb3JhdmFudGk=')
    end
    private_class_method :speakerdeck

    def self.vimeo
      d('aHR0cHM6Ly92aW1lby5jb20vcGF1bGZpb3JhdmFudGk=')
    end
    private_class_method :vimeo

    def self.code_school
      d('aHR0cDovL3d3dy5jb2Rlc2Nob29sLmNvbS91c2Vycy9wYXVsZmlvcmF2YW50aQ==')
    end
    private_class_method :code_school

    def self.twitter
      d('aHR0cHM6Ly90d2l0dGVyLmNvbS9wZWZpb3JhdmFudGk=')
    end
    private_class_method :twitter

    def self.blog
      d('aHR0cDovL3BhdWxmaW9yYXZhbnRpLmNvbS9hYm91dA==')
    end
    private_class_method :blog

    def self.rc
      d('aHR0cDovL3d3dy5yYXRlY2l0eS5jb20uYXUv')
    end
    private_class_method :rc

    def self.ruby
      d('aHR0cDovL3d3dy5ydWJ5LWxhbmcub3JnL2VuLw==')
    end
    private_class_method :ruby

    def self.rails
      d('aHR0cDovL3J1YnlvbnJhaWxzLm9yZy8=')
    end
    private_class_method :rails

    def self.gw
      d('aHR0cDovL3d3dy5ndWlkZXdpcmUuY29tLw==')
    end
    private_class_method :gw

    def self.rnt
      d("aHR0cDovL3d3dy5vcmFjbGUuY29tL3VzL3Byb2R1Y3RzL2FwcGxpY2F0aW9uc"\
        "y9yaWdodG5vdy9vdmVydmlldy9pbmRleC5odG1s")
    end
    private_class_method :rnt

    def self.sra
      d('aHR0cDovL3d3dy5zcmEuY28uanAvaW5kZXgtZW4uc2h0bWw=')
    end
    private_class_method :sra

    def self.jet
      d("aHR0cDovL3d3dy5qZXRwcm9ncmFtbWUub3JnL2UvYXNwaXJpbmcvcG9zaXRpb25"\
        "zLmh0bWw=")
    end
    private_class_method :jet

    def self.satc
      d('aHR0cDovL3d3dy5zb3V0aGF1c3RyYWxpYS5jb20v')
    end
    private_class_method :satc

    def self.mit
      d('aHR0cHM6Ly93d3cudW5pc2EuZWR1LmF1Lw==')
    end
    private_class_method :mit

    def self.bib
      d('aHR0cDovL3d3dy5mbGluZGVycy5lZHUuYXUv')
    end
    private_class_method :bib

    def self.ryu
      d('aHR0cDovL3d3dy5yeXVrb2t1LmFjLmpwL2VuZ2xpc2gyL2luZGV4LnBocA==')
    end
    private_class_method :ryu

    def self.tafe
      d('aHR0cDovL3d3dy50YWZlc2EuZWR1LmF1')
    end
    private_class_method :tafe
  end

  class Image
    def self.for(resource)
      send(:"#{resource}")
    end

    def self.background
      open('http://farm6.staticflickr.com/5453/8801916021_3ac1df6072_o_d.jpg')
    end
    private_class_method :background

    def self.email
      open('http://farm3.staticflickr.com/2826/8753727736_2a7a294527_m.jpg')
    end
    private_class_method :email

    def self.linked_in
      open('http://farm4.staticflickr.com/3687/8809717292_4938937a94_m.jpg')
    end
    private_class_method :linked_in

    def self.github
      open('http://farm4.staticflickr.com/3828/8799239149_d23e4acff0_m.jpg')
    end
    private_class_method :github

    def self.stackoverflow
      open('http://farm3.staticflickr.com/2815/8799253647_e4ec3ab1bc_m.jpg')
    end
    private_class_method :stackoverflow

    def self.speakerdeck
      open('http://farm8.staticflickr.com/7404/8799250189_4125b90a14_m.jpg')
    end
    private_class_method :speakerdeck

    def self.vimeo
      open('http://farm9.staticflickr.com/8546/8809862216_0cdd40c3dc_m.jpg')
    end
    private_class_method :vimeo

    def self.code_school
      open('http://farm4.staticflickr.com/3714/9015339024_0651daf2c4_m.jpg')
    end
    private_class_method :code_school

    def self.twitter
      open('http://farm3.staticflickr.com/2837/8799235993_26a7d17540_m.jpg')
    end
    private_class_method :twitter

    def self.blog
      open('http://farm4.staticflickr.com/3752/8809826162_e4d765d15b_m.jpg')
    end
    private_class_method :blog

    def self.rc
      open('http://farm6.staticflickr.com/5484/9192095974_b49a1fc142_m.jpg')
    end
    private_class_method :rc

    def self.ruby
      open('http://farm4.staticflickr.com/3793/8799953079_33cfdc0def_m.jpg')
    end
    private_class_method :ruby

    def self.rails
      open('http://farm4.staticflickr.com/3681/8810534562_dfc34ea70c_m.jpg')
    end
    private_class_method :rails

    def self.gw
      open('http://farm8.staticflickr.com/7376/8812488914_f0bfd0a841_m.jpg')
    end
    private_class_method :gw

    def self.rnt
      open('http://farm8.staticflickr.com/7326/8801904137_e6008ee907_m.jpg')
    end
    private_class_method :rnt

    def self.sra
      open('http://farm4.staticflickr.com/3801/8801903945_723a5d7276_m.jpg')
    end
    private_class_method :sra

    def self.jet
      open('http://farm4.staticflickr.com/3690/8801904135_37197a468c_m.jpg')
    end
    private_class_method :jet

    def self.satc
      open('http://farm4.staticflickr.com/3804/8801903991_103f5a47f8_m.jpg')
    end
    private_class_method :satc

    def self.mit
      open('http://farm4.staticflickr.com/3792/8812488692_96818be468_m.jpg')
    end
    private_class_method :mit

    def self.bib
      open('http://farm4.staticflickr.com/3707/8812488974_71c6981155_m.jpg')
    end
    private_class_method :bib

    def self.ryu
      open('http://farm8.staticflickr.com/7428/8812488856_c4c1b1f418_m.jpg')
    end
    private_class_method :ryu

    def self.tafe
      open('http://farm8.staticflickr.com/7377/8812488734_e43ce6742b_m.jpg')
    end
    private_class_method :tafe
  end

  class Resource
    attr_reader :image, :link

    def self.for(name)
      new(image: Image.for(:"#{name}"), link: Link.for(:"#{name}"))
    end

    private

    def initialize(options)
      options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end

  module ResumeHelper
    private

    def bullet_list(*items)
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [] })
    end

    def social_media_links
      resources = social_media_resources
      x_position = 0
      bounding_box_for(resources.first, x_position)
      x_position += 45
      resources[1..-1].each do |image_link|
        move_up 46.25
        bounding_box_for(image_link, x_position)
        x_position += 45
      end
    end

    def bounding_box_for(image_link, x_position)
      bounding_box([x_position, cursor], width: 35) do
        image image_link.image, fit: [35, 35], align: :center
        move_up 35
        transparent(0) do
          formatted_text([{
            text: '|||',
            size: 40,
            link: image_link.link
          }], align: :center)
        end
      end
    end

    def social_media_resources
      %w(email linked_in github stackoverflow
         speakerdeck vimeo code_school blog).map do |item|
        Resource.for(item)
      end
    end

    def heading(string)
      formatted_text([{ text: d(string), styles: [:bold], color: '666666' }])
    end

    def name(string)
      font('Times-Roman', size: 20) { text d(string) }
    end

    def description(ruby, rest)
      formatted_text(
        [
          { text: d(ruby), color: '85200C' },
          { text: d(rest) }
        ],
        size: 14
      )
    end

    def position(title, options = {})
      if options.has_key?(:at)
        formatted_text_box(
          [{ text: d(title), styles: [:bold] }], at: [options[:at], cursor]
        )
      else
        formatted_text([{ text: d(title), styles: [:bold] }])
      end
    end

    def organisation(name, options = {})
      if options.has_key?(:at)
        formatted_text_box(
          [{ text: d(name), styles: [:bold], size: 11 }],
          at: [options[:at], cursor]
        )
      else
        formatted_text([{ text: d(name), styles: [:bold], size: 11 }])
      end
    end

    def period_and_location(options)
      if options.has_key?(:at)
        formatted_text_box(
          [
            { text: d(options[:period]), color: '666666', size: 10 },
            {
              text: d(options[:location]),
              link: d(options[:link]),
              color: '666666', size: 10
            }
          ],
          at: [options[:at], cursor]
        )
      else
        formatted_text([
          { text: d(options[:period]) },
          {
            text: d(options[:location]),
            link: d(options[:link])
          }
        ], color: '666666', size: 10)
      end
    end

    def organisation_logo(options)
      bounding_box([options[:origin], cursor],
                   width: options[:width],
                   height: options[:height]) do
        image Image.for(options[:organisation]),
              fit: options[:fit],
              align: :center
        move_up options[:move_up]
        transparent(0) do
          formatted_text([{
            text: '|' * options[:bars],
            size: options[:size],
            link: Link.for(options[:organisation])
          }])
        end
      end
    end
  end

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

if __FILE__ == $0
  ResumeGenerator::CLI.new.start
end