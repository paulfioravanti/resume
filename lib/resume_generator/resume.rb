require 'json'
require 'open-uri'
require 'decodable'
require 'name'
require 'social_media_icon_set'
require 'listing'

module ResumeGenerator
  # Resume cannot be declared as a Prawn::Document (ie inherit from it)
  # because at the time someone runs the script, it is not certain that they
  # have any of the required Prawn gems installed. Explicit declaration of this
  # kind of inheritance hierarchy in advance will result in an
  # uninitialized constant ResumeGenerator::Prawn error.
  class Resume
    include Decodable

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
      patch_prawn_document
      Prawn::Document.generate(filename, pdf_options) do
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
    rescue SocketError
      cli.inform_of_network_connection_issue
      exit
    end

    def self.patch_prawn_document
      Prawn::Document.class_eval do
        include ResumeHelper

        def resume
          Resume.resume
        end
      end
    end
    private_class_method :patch_prawn_document

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

    module ResumeHelper
      include Decodable

      private

      def name
        Name.generate(self, resume[:name])
      end

      def headline
        headline = resume[:headline]
        formatted_text(
          [
            {
              text: d(headline[:ruby][:text]),
              color: headline[:ruby][:colour]
            },
            { text: d(headline[:other][:text]) }
          ],
          size: headline[:size]
        )
      end

      def social_media_icons
        SocialMediaIconSet.generate(self, resume[:social_media])
      end

      def technical_skills
        tech_skills = resume[:tech_skills]
        heading_for(tech_skills)
        move_down tech_skills[:content_top_padding]
        table_data = tech_skills[:content].reduce([]) do |data, entry|
          data << [d(entry.first), d(entry.last)]
        end
        table(table_data, tech_skills[:properties])
      end

      def employment_history
        history = resume[:employment_history]
        heading_for(history)
        history[:entries].each do |_, entry|
          Listing.generate(self, entry)
        end
        move_down history[:bottom_padding]
        stroke_horizontal_rule { color history[:horizontal_rule_colour] }
      end

      def education_history
        history = resume[:education_history]
        heading_for(history)
        history[:entries].each do |_, entry|
          Listing.generate(self, entry)
        end
      end

      def heading_for(section)
        move_down section[:top_padding]
        formatted_text([{
          text: d(section[:heading]),
          styles: section[:heading_styles].map(&:to_sym),
          color: section[:heading_colour]
        }])
      end
    end
  end
end
