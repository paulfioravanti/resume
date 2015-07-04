#!/usr/bin/env ruby
# encoding: UTF-8
require 'prawn'
require 'base64'
require 'open-uri'
# Third party gem that will need installing
require 'zip'
require 'fileutils'

ipa_fonts = 'IPAfont00303.zip'
open(ipa_fonts, 'wb') do |file|
  open("http://ipafont.ipa.go.jp/ipafont/IPAfont00303.php") do |uri|
    file.write(uri.read)
  end
end
ipa_mincho = 'ipamp.ttf'
ipa_gothic = 'ipagp.ttf'
Zip::File.open(ipa_fonts) do |file|
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
  font_families.update('IPAFonts' => {
    normal: ipa_mincho,
    bold: ipa_gothic
  })
  font 'IPAFonts'
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
FileUtils.rm([ipa_fonts, ipa_mincho, ipa_gothic])
