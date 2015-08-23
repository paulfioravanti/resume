require_relative '../decoder'
require_relative 'manifest'
require_relative 'options'

module Resume
  module PDF
    # This class cannot be declared as a Prawn::Document
    # (ie inherit from it) because at the time someone runs the script,
    # it is not certain that they have any of the required Prawn gems
    # installed. Explicit declaration of this kind of inheritance
    # hierarchy in advance will result in an uninitialized constant error.
    class Document
      include Decoder

      def self.generate(resume, title, filename)
        new(resume, title, filename).generate
      end

      private_class_method :new

      def initialize(resume, title, filename)
        @resume = resume
        @title = title
        @filename = filename
      end

      def generate
        require 'prawn'
        require 'prawn/table'
        Prawn::Document.generate(filename, options) do |pdf|
          pdf.instance_exec(resume) do |resume|
            Manifest.process(self, resume)
          end
        end
        self
      end

      private

      attr_reader :resume, :title, :filename

      def options
        Options.generate(title, resume[:options])
      end
    end
  end
end
