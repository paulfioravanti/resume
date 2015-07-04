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
      def self.process(pdf, resume, app)
        Font.configure(pdf, resume[:font], app.locale)
        Name.generate(pdf, resume[:name])
        # TODO: Headline needs some top padding in Japanese
        Headline.generate(pdf, resume[:headline])
        app.inform_creation_of_social_media_links
        SocialMediaLogoSet.generate(
          pdf, resume[:social_media_logo_set]
        )
        app.inform_creation_of_technical_skills
        TechnicalSkills.generate(pdf, resume[:technical_skills])
        # app.inform_creation_of_employment_history
        # EmploymentHistory.generate(pdf, resume[:employment_history])
        # app.inform_creation_of_education_history
        # EducationHistory.generate(pdf, resume[:education_history])
      end
    end
  end
end
