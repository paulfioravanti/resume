require 'json'
require 'open-uri'
require_relative '../decoder'
require_relative 'name'
require_relative 'headline'
require_relative 'social_media_logo_set'
require_relative 'technical_skills'
require_relative 'employment_history'
require_relative 'education_history'
require_relative 'document'

module ResumeGenerator
  module Resume
    # This class cannot be declared as a Prawn::Document (ie inherit from it)
    # because at the time someone runs the script, it is not certain that they
    # have any of the required Prawn gems installed. Explicit declaration of this
    # kind of inheritance hierarchy in advance will result in an
    # uninitialized constant error.
    class Generator
      include Decoder

      attr_reader :resume, :app

      def self.start(app)
        resume = JSON.parse(
          open("resources/resume.#{ResumeGenerator.locale}.json").read,
          symbolize_names: true
        )[:resume]
        app.filename =
          "#{d(resume[:document_name])}_#{ResumeGenerator.locale}.pdf"
        new(resume, app).start
      rescue SocketError
        app.inform_of_network_connection_issue
        exit
      end

      def start
        Prawn::Document.generate(app.filename, pdf_options) do |pdf|
          pdf.instance_exec(resume, app) do |resume, app|
            Document.generate(self, resume, app)
          end
        end
      end

      private

      def initialize(resume, app)
        @resume = resume
        @app = app
      end

      def pdf_options
        {
          margin_top: resume[:margin_top],
          margin_bottom: resume[:margin_bottom],
          margin_left: resume[:margin_left],
          margin_right: resume[:margin_right],
          background: open(resume[:background_image]),
          repeat: resume[:repeat],
          info: {
            Title: d(resume[:document_name]),
            Author: d(resume[:author]),
            Creator: d(resume[:author]),
            CreationDate: Time.now
          }
        }
      end
    end
  end
end

