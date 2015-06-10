require 'json'
require 'open-uri'
require 'socket'
require_relative '../decoder'
require_relative 'manifest'
require_relative 'options'

module Resume
  module PDF
    # This class cannot be declared as a Prawn::Document (ie inherit from it)
    # because at the time someone runs the script, it is not certain that they
    # have any of the required Prawn gems installed. Explicit declaration of this
    # kind of inheritance hierarchy in advance will result in an
    # uninitialized constant error.
    class Document
      include Decoder

      attr_reader :resume, :app

      def self.generate(app)
        locale = app.locale
        resume = JSON.parse(
          open("#{DATA_LOCATION}resume.#{locale}.json").read,
          symbolize_names: true
        )[:resume]
        app.filename = "#{d(resume[:document_name])}_#{locale}.pdf"
        new(resume, app).generate
      rescue SocketError
        app.inform_of_network_connection_issue
        exit
      end

      def initialize(resume, app)
        @resume = resume
        @app = app
      end

      def generate
        require 'prawn'
        require 'prawn/table'
        Prawn::Document.generate(app.filename, Options.for(resume)) do |pdf|
          pdf.instance_exec(resume, app) do |resume, app|
            Manifest.process(self, resume, app)
          end
        end
      end
    end
  end
end
