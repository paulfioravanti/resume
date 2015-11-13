require_relative 'manifest'

module Resume
  module PDF
    # This class cannot be declared as a Prawn::Document
    # (ie inherit from it) because at the time someone runs the script,
    # it is not certain that they have any of the required Prawn gems
    # installed. Explicit declaration of this kind of inheritance
    # hierarchy in advance will result in an uninitialized constant error.
    class Document
      def self.generate(resume, title, filename)
        require 'prawn'
        require 'prawn/table'
        Prawn::Document.generate(filename, options(title, resume)) do |pdf|
          pdf.instance_exec(resume) do |document|
            Manifest.process(self, document)
          end
        end
      end

      def self.options(title, resume)
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
