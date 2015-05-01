module ResumeGenerator
  module Resume
    class Document
      def self.generate(pdf, app)
        Name.generate(pdf, Generator.data[:name])
        Headline.generate(pdf, Generator.data[:headline])
        app.inform_creation_of_social_media_links
        SocialMediaLogoSet.generate(
          pdf, Generator.data[:social_media_logo_set]
        )
        app.inform_creation_of_technical_skills
        TechnicalSkills.generate(pdf, Generator.data[:technical_skills])
        app.inform_creation_of_employment_history
        EmploymentHistory.generate(pdf, Generator.data[:employment_history])
        app.inform_creation_of_education_history
        EducationHistory.generate(pdf, Generator.data[:education_history])
      end
    end
  end
end
