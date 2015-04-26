require 'json'
require 'open-uri'
require 'decoder'
require 'name'
require 'headline'
require 'social_media_icon_set'
require 'technical_skills'
require 'employment_history'
require 'education_history'
require 'listing'

module ResumeGenerator
  # Resume cannot be declared as a Prawn::Document (ie inherit from it)
  # because at the time someone runs the script, it is not certain that they
  # have any of the required Prawn gems installed. Explicit declaration of this
  # kind of inheritance hierarchy in advance will result in an
  # uninitialized constant ResumeGenerator::Prawn error.
  class Resume
    include Decoder

    def self.resume
      @@resume ||= JSON.parse(
        open("resources/resume.#{ResumeGenerator.locale}.json").read,
        symbolize_names: true
      )[:resume]
    end

    def self.filename
      @@filename ||=
        "#{d(resume[:document_name])}_#{ResumeGenerator.locale}.pdf"
    end

    def self.generate(cli)
      Prawn::Document.generate(filename, pdf_options) do
        Name.generate(self, Resume.resume[:name])
        Headline.generate(self, Resume.resume[:headline])
        cli.inform_creation_of_social_media_links
        SocialMediaIconSet.generate(self, Resume.resume[:social_media])
        cli.inform_creation_of_technical_skills
        TechnicalSkills.generate(self, Resume.resume[:tech_skills])
        cli.inform_creation_of_employment_history
        EmploymentHistory.generate(self, Resume.resume[:employment_history])
        cli.inform_creation_of_education_history
        EducationHistory.generate(self, Resume.resume[:education_history])
      end
    rescue SocketError
      cli.inform_of_network_connection_issue
      exit
    end

    def self.pdf_options
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
    private_class_method :pdf_options
  end
end
