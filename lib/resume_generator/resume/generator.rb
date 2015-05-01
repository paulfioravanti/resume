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

      def self.data
        @resume ||= JSON.parse(
          open("resources/resume.#{ResumeGenerator.locale}.json").read,
          symbolize_names: true
        )[:resume]
      end

      def self.filename
        @filename ||=
          "#{d(data[:document_name])}_#{ResumeGenerator.locale}.pdf"
      end

      def self.start(app)
        Prawn::Document.generate(filename, pdf_options) do
          Document.generate(self, app)
        end
      rescue SocketError
        app.inform_of_network_connection_issue
        exit
      end

      def self.pdf_options
        {
          margin_top: data[:margin_top],
          margin_bottom: data[:margin_bottom],
          margin_left: data[:margin_left],
          margin_right: data[:margin_right],
          background: open(data[:background_image]),
          repeat: data[:repeat],
          info: {
            Title: d(data[:document_name]),
            Author: d(data[:author]),
            Creator: d(data[:author]),
            CreationDate: Time.now
          }
        }
      end
      private_class_method :pdf_options
    end
  end
end

