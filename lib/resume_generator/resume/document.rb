require 'json'
require 'open-uri'
require_relative '../decoder'
require_relative 'name'
require_relative 'headline'
require_relative 'social_media_icon_set'
require_relative 'technical_skills'
require_relative 'employment_history'
require_relative 'education_history'

module ResumeGenerator
  # Resume cannot be declared as a Prawn::Document (ie inherit from it)
  # because at the time someone runs the script, it is not certain that they
  # have any of the required Prawn gems installed. Explicit declaration of this
  # kind of inheritance hierarchy in advance will result in an
  # uninitialized constant ResumeGenerator::Prawn error.
  module Resume
    class Document
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

      def self.generate(cli)
        Prawn::Document.generate(filename, pdf_options) do
          Name.generate(self, Document.data[:name])
          Headline.generate(self, Document.data[:headline])
          cli.inform_creation_of_social_media_links
          SocialMediaIconSet.generate(self, Document.data[:social_media])
          cli.inform_creation_of_technical_skills
          TechnicalSkills.generate(self, Document.data[:technical_skills])
          cli.inform_creation_of_employment_history
          EmploymentHistory.generate(self, Document.data[:employment_history])
          cli.inform_creation_of_education_history
          EducationHistory.generate(self, Document.data[:education_history])
        end
      rescue SocketError
        cli.inform_of_network_connection_issue
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

