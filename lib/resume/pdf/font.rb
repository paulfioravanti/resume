require 'tmpdir'

module Resume
  module PDF
    class Font
      def self.configure(pdf, font)
        font_name = font[:name]
        unless Prawn::Font::AFM::BUILT_INS.include?(font_name)
          pdf.font_families.update(
            font_name => {
              normal: tmp_filepath(font[:normal]),
              bold: tmp_filepath(font[:bold])
            }
          )
        end
        pdf.font font_name
      end

      def self.tmp_filepath(file)
        File.join(Dir.tmpdir, file)
      end
      private_class_method :tmp_filepath
    end
  end
end
