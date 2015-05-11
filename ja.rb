#!/usr/bin/env ruby
# encoding: UTF-8
require 'prawn'
require 'base64'
require 'open-uri'
# Third party gem that will need installing
require 'zip'
require 'fileutils'

ipa_2_fonts = 'IPAexfont00201.zip'
open(ipa_2_fonts, 'wb') do |file|
  open("http://ipafont.ipa.go.jp/ipaexfont/IPAexfont00201.php") do |uri|
    file.write(uri.read)
  end
end
ipa_mincho = 'ipaexm.ttf'
ipa_gothic = 'ipaexg.ttf'
Zip::File.open(ipa_2_fonts) do |file|
  file.each do |entry|
    [ipa_mincho, ipa_gothic].each do |name|
      if entry.name.match(name)
        entry.extract(name)
        break # inner loop only
      end
    end
  end
end
Prawn::Document.generate('ja.pdf') do
  font_families.update('IPAexFonts' => {
    normal: ipa_mincho,
    bold: ipa_gothic
  })
  font 'IPAexFonts'
  formatted_text [
    {
      text: Base64.strict_decode64("UnVieemWi+eZuuiAhSA=").
            force_encoding('utf-8'),
      color: '85200C'
    },

    {
      text: Base64.strict_decode64("UnVieemWi+eZuuiAhSA=").
            force_encoding('utf-8'),
      styles: [:bold]
    }
  ]
end
FileUtils.rm([ipa_2_fonts, ipa_mincho, ipa_gothic])
