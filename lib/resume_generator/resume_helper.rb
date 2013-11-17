require 'json'
require 'open-uri'
require 'social_media_helper'
require 'resume_entry_helper'

module ResumeGenerator
  module ResumeHelper
    include SocialMediaHelper, ResumeEntryHelper

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

    def social_media_resources
      social_media = RESUME[:social_media]
      social_media[:resources].values.map do |social_medium|
        social_medium.merge!(social_media[:properties])
        Resource.for(social_medium)
      end
    end

    def header_text_for(position, y_start = 15)
      entry = RESUME[:entries][position]
      move_down y_start
      return formatted_text_boxes_for(entry) if entry[:at]
      formatted_text_fields_for(entry)
    end

    def content_for(position, start_point = 10)
      entry = RESUME[:entries][position]
      move_down start_point
      summary(entry[:summary])
      profile(entry[:profile])
    end

    def logo_resource(position, logo)
      entry = RESUME[:entries][position]
      organisation_logo = entry[:logos][logo]
      organisation_logo.merge!(at: entry[:at])
      Resource.for(organisation_logo)
    end
  end
end
