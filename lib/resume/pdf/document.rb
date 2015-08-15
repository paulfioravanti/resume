require 'json'
require 'open-uri'
require 'socket'
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

      attr_reader :resume, :filename

      def self.generate(resume)
        new(resume).generate
      end

      def initialize(resume)
        @resume = resume
        @filename = "#{d(resume[:document_name])}_#{locale}.pdf"
      end

      def generate
        require 'prawn'
        require 'prawn/table'
        Prawn::Document.generate(filename, Options.for(resume)) do |pdf|
          pdf.instance_exec(resume) do |resume|
            Manifest.process(self, resume)
          end
        end
      end
    end
  end
end
