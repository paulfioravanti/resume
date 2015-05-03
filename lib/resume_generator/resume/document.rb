require 'json'
require 'open-uri'
require_relative '../decoder'
require_relative 'name'
require_relative 'headline'
require_relative 'social_media_logo_set'
require_relative 'technical_skills'
require_relative 'employment_history'
require_relative 'education_history'
require_relative 'manifest'
require_relative 'pdf_options'

module ResumeGenerator
  module Resume
    # This class cannot be declared as a Prawn::Document (ie inherit from it)
    # because at the time someone runs the script, it is not certain that they
    # have any of the required Prawn gems installed. Explicit declaration of this
    # kind of inheritance hierarchy in advance will result in an
    # uninitialized constant error.
    class Document
      include Decoder

      attr_reader :resume, :app

      def self.generate(app)
        resume = JSON.parse(
          open("resources/resume.#{app.locale}.json").read,
          symbolize_names: true
        )[:resume]
        app.filename =
          "#{d(resume[:document_name])}_#{app.locale}.pdf"
        new(resume, app).generate
      rescue SocketError
        app.inform_of_network_connection_issue
        exit
      end

      def generate
        Prawn::Document.generate(app.filename, PDFOptions.for(resume)) do |pdf|
          pdf.instance_exec(resume, app) do |resume, app|
            Manifest.process(self, resume, app)
          end
        end
      end

      private

      def initialize(resume, app)
        @resume = resume
        @app = app
      end
    end
  end
end

