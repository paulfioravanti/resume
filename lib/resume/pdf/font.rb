module Resume
  module PDF
    class Font
      def self.configure(pdf, font)
        pdf.font font[:name]
      end
    end
  end
end
