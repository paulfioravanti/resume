require_relative "../output"
require_relative "font"
require_relative "name"
require_relative "headline"
require_relative "social_media_logo_set"
require_relative "technical_skills"
require_relative "employment_history"
require_relative "education_history"

module Resume
  module PDF
    # Module outlining the list of sections to generate for the PDF resume.
    #
    # @author Paul Fioravanti
    module Manifest
      module_function

      # Runs the process of telling each section of the PDF resume
      # to generate itself.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to on which to apply the sections.
      # @param resume [Hash]
      #   Hash containing all data relating to the resume.
      def process(pdf, resume)
        Font.configure(pdf, resume[:font])
        Name.generate(pdf, resume[:name])
        Headline.generate(pdf, resume[:headline])
        Output.plain(:creating_social_media_links)
        SocialMediaLogoSet.generate(pdf, resume[:social_media_logo_set])
        Output.plain(:creating_technical_skills_section)
        TechnicalSkills.generate(pdf, resume[:technical_skills])
        Output.plain(:creating_employment_history_section)
        EmploymentHistory.generate(pdf, resume[:employment_history])
        Output.plain(:creating_education_history_section)
        EducationHistory.generate(pdf, resume[:education_history])
      end
    end
  end
end
