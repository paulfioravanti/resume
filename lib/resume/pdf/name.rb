module Resume
  module PDF
    module Name
      module_function

      def generate(pdf, name)
        pdf.font(name[:font], size: name[:size]) do
          pdf.text(name[:text])
        end
      end
    end
  end
end
