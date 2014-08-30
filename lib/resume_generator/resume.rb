require 'json'
require 'open-uri'
require 'decodable'
require 'social_media_icon_set'
require 'listing'

module ResumeGenerator
  # Resume cannot be declared as a Prawn::Document (ie inherit from it)
  # because at the time someone runs the script, it is not certain that they
  # have any of the required Prawn gems installed. Explicit declaration of this
  # kind of inheritance hierarchy in advance as it will result in an
  # uninitialized constant ResumeGenerator::Prawn error.
  class Resume
    include Decodable

    RESUME = JSON.parse(
      open('resources/resume.json').read,
      symbolize_names: true
    )[:resume]

    def self.generate(cli)
      Prawn::Document.class_eval do
        include ResumeHelper
      end
      Prawn::Document.generate("#{d(DOCUMENT_NAME)}.pdf", pdf_options) do
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
        background: open(RESUME[:background_image]),
        repeat: true,
        info: {
          Title: d(DOCUMENT_NAME),
          Author: d('UGF1bCBGaW9yYXZhbnRp'),
          Creator: d('UGF1bCBGaW9yYXZhbnRp'),
          CreationDate: Time.now
        }
      }
    end
    private_class_method :pdf_options

    module ResumeHelper
      include Decodable

      private

      def name
        font('Times-Roman', size: 20) { text d(RESUME[:name]) }
      end

      def headline
        headline = RESUME[:headline]
        formatted_text(
          [
            { text: d(headline[:ruby]), color: '85200C' },
            { text: d(headline[:other]) }
          ],
          size: 14
        )
      end

      def social_media_icons
        move_down 5
        SocialMediaIconSet.generate(self, RESUME[:social_media])
        stroke_horizontal_rule { color '666666' }
      end

      def technical_skills
        heading d('VGVjaG5pY2FsIFNraWxscw==')
        move_down 5
        skills = RESUME[:tech_skills]
        table_data = skills[:content].reduce([]) do |data, entry|
          data << [d(entry.first), d(entry.last)]
        end
        table(table_data, skills[:properties])
      end

      def employment_history
        heading d('RW1wbG95bWVudCBIaXN0b3J5')
        entries = RESUME[:entries]
        [:rc, :fl, :gw, :rnt, :sra, :jet, :satc].each do |entry|
          Listing.generate(self, entries[entry])
        end
        move_down 10
        stroke_horizontal_rule { color '666666' }
      end

      def education_history
        heading d('RWR1Y2F0aW9u')
        entries = RESUME[:entries]
        [:mit, :bib, :ryu, :tafe].each do |entry|
          Listing.generate(self, entries[entry])
        end
      end

      def heading(string)
        move_down 10
        formatted_text([{ text: string, styles: [:bold], color: '666666' }])
      end
    end
  end
end
