require 'resume_helper'

module ResumeGenerator
  class Resume
    def self.generate(cli)
      Prawn::Document.class_eval do
        include ResumeHelper
      end
      Prawn::Document.generate("#{DOCUMENT_NAME}.pdf", pdf_options) do
        name
        headline
        cli.inform_creation_of_social_media_links
        social_media_icons
        cli.inform_creation_of_technical_skills
        technical_skills
        cli.inform_creation_of_employment_history
        employment_history
        cli.inform_creation_of_education_history
        education_history
      end
    end

    def self.pdf_options
      {
        margin_top: 0.75,
        margin_bottom: 0.75,
        margin_left: 1,
        margin_right: 1,
        background: background_image,
        repeat: true
      }
    end
    private_class_method :pdf_options
  end
end
