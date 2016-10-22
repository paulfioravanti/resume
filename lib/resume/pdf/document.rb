require_relative "manifest"

module Resume
  module PDF
    module Document
      module_function

      def generate(resume, title, filename)
        require "prawn"
        require "prawn/table"
        Prawn::Document.generate(filename, options(title, resume)) do |pdf|
          pdf.instance_exec(resume) do |document|
            Manifest.process(self, document)
          end
        end
      end

      def options(title, resume)
        author = resume[:author]
        {
          margin_top: resume[:margin_top],
          margin_bottom: resume[:margin_bottom],
          margin_left: resume[:margin_left],
          margin_right: resume[:margin_right],
          background: resume[:background_image],
          repeat: resume[:repeat],
          info: {
            Title: title,
            Author: author,
            Creator: author,
            CreationDate: Time.now
          }
        }
      end
      private_class_method :options
    end
  end
end
