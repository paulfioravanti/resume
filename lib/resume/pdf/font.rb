require 'tmpdir'

module Resume
  module PDF
    class Font
      def self.configure(pdf, font)
        font_name = font[:name]
        unless Prawn::Font::AFM::BUILT_INS.include?(font_name)
          pdf.font_families.update(
            font_name => {
              normal: font_file(font[:normal]),
              bold: font_file(font[:bold])
            }
          )
        end
        pdf.font font_name
      end

      def self.font_file(name)
        File.join(Dir.tmpdir, name)
      end
      private_class_method :font_file
    end
  end
end
