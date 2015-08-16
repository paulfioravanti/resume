require_relative '../output'
require_relative 'font'
require_relative 'name'
require_relative 'headline'
require_relative 'social_media_logo_set'
require_relative 'technical_skills'
require_relative 'employment_history'
require_relative 'education_history'

module Resume
  module PDF
    class Manifest
      def self.process(pdf, resume)
        Font.configure(pdf, resume[:font])
        Name.generate(pdf, resume[:name])
        Headline.generate(pdf, resume[:headline])
        Output.info(:creating_social_media_links)
        SocialMediaLogoSet.generate(
          pdf, resume[:social_media_logo_set]
        )
        Output.info(:creating_technical_skills_section)
        TechnicalSkills.generate(pdf, resume[:technical_skills])
        Output.info(:creating_employment_history_section)
        EmploymentHistory.generate(pdf, resume[:employment_history])
        Output.info(:creating_education_history_section)
        EducationHistory.generate(pdf, resume[:education_history])
      end
    end
  end
end
