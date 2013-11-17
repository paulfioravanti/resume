require 'json'
require 'open-uri'
require 'resume_entry_helper'

module ResumeGenerator
  module ResumeHelper
    include ResumeEntryHelper

    RESUME =
      JSON.parse(
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
          {
            text: d(headline[:ruby]), color: '85200C'
          },
          {
            text: d(headline[:other])
          }
        ],
        size: 14
      )
    end

    def social_media_icons
      social_media = RESUME[:social_media]
      move_down 5
      resources = resources_for(social_media)
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

    def employment_history
      heading d('RW1wbG95bWVudCBIaXN0b3J5')
      entries = RESUME[:entries]
      rc(entries[:rc])
      fl(entries[:fl])
      gw(entries[:gw])
      rnt(entries[:rnt])
      sra(entries[:sra])
      jet(entries[:jet])
      satc(entries[:satc])
      move_down 10
      stroke_horizontal_rule { color '666666' }
    end

    def education_history
      heading d('RWR1Y2F0aW9u')
      entries = RESUME[:entries]
      mit(entries[:mit])
      bib(entries[:bib])
      ryu(entries[:ryu])
      tafe(entries[:tafe])
    end
  end
end
