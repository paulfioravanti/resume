require_relative "manifest"

module Resume
  module PDF
    # Module representing the PDF document itself.
    #
    # @author Paul Fioravanti
    module Document
      module_function

      # Generates the PDF document.
      #
      # @param resume [Hash]
      #   Contains all content to be used in generating the resume.
      # @param title [String]
      #   The resume title to use in the document's metadata.
      # @param filename [String]
      #   The name of the filename to be generated.
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
        options = resume[:options]
        author = options[:author]
        {
          margin_top: options[:margin_top],
          margin_bottom: options[:margin_bottom],
          margin_left: options[:margin_left],
          margin_right: options[:margin_right],
          background: options[:background_image],
          repeat: options[:repeat],
          info: {
            Title: title,
            Author: author,
            Creator: options[:repo_link],
            CreationDate: Time.now
          }
        }
      end
      private_class_method :options
    end
  end
end
