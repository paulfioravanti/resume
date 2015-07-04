module Resume
  module PDF
    class Font
      def self.configure(pdf, font, locale)
        if locale == :ja
          pdf.font_families.update(font[:name] => {
            # normal: ipa_mincho,
            # bold: ipa_gothic
            # FIXME: get this info from the resume
            normal: 'ipamp.ttf',
            bold: 'ipagp.ttf'
          })
        end
        pdf.font font[:name]
      end
    end
  end
end
