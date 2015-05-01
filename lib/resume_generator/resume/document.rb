module ResumeGenerator
  module Resume
    class Document
      def self.generate(pdf, resume, app)
        Name.generate(pdf, resume[:name])
        Headline.generate(pdf, resume[:headline])
        app.inform_creation_of_social_media_links
        SocialMediaLogoSet.generate(
          pdf, resume[:social_media_logo_set]
        )
        app.inform_creation_of_technical_skills
        TechnicalSkills.generate(pdf, resume[:technical_skills])
        app.inform_creation_of_employment_history
        EmploymentHistory.generate(pdf, resume[:employment_history])
        app.inform_creation_of_education_history
        EducationHistory.generate(pdf, resume[:education_history])
      end
    end
  end
end
