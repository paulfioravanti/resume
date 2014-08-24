require 'json'
require 'open-uri'
require 'decodable'
require 'utilities'

module ResumeGenerator
  module ResumeHelper
    include Decodable, Utilities

    RESUME = JSON.parse(
      open('resources/resume.json').read,
      symbolize_names: true
    )[:resume]

    def self.included(base)
      Resume.extend(ClassMethods)
    end

    module ClassMethods
      def background_image
        open(RESUME[:background_image])
      end
    end

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
      resources = resources_for(RESUME[:social_media])
      x_position = 0
      social_media_icon_for(resources.first, x_position)
      x_position += 45
      resources[1..-1].each do |resource|
        move_up 46.25
        social_media_icon_for(resource, x_position)
        x_position += 45
      end
      stroke_horizontal_rule { color '666666' }
    end

    def technical_skills
      heading d("VGVjaG5pY2FsIFNraWxscw==")
      move_down 5
      tech_skills = RESUME[:tech_skills]
      table_data = tech_skills[:content].reduce([]) do |data, entry|
        data << [d(entry.first), d(entry.last)]
      end
      table(table_data, tech_skills[:properties])
    end

    def employment_history
      heading d('RW1wbG95bWVudCBIaXN0b3J5')
      entries = RESUME[:entries]
      [:rc, :fl, :gw, :rnt, :sra, :jet, :satc].each do |entry|
        listing_for(entries[entry])
      end
      move_down 10
      stroke_horizontal_rule { color '666666' }
    end

    def education_history
      heading d('RWR1Y2F0aW9u')
      entries = RESUME[:entries]
      [:mit, :bib, :ryu, :tafe].each do |entry|
        listing_for(entries[entry])
      end
    end
  end
end
