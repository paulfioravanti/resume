module Resume
  module PDF
    class Name
      def self.generate(pdf, name)
        pdf.font(name[:font], size: name[:size]) do
          pdf.text(name[:text])
        end
      end
    end
  end
end
