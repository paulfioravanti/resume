require 'utilities'

module ResumeGenerator
  module Sociable
    include Utilities

    def resources_for(social_media)
      social_media[:resources].values.map do |social_medium|
        social_medium.merge!(social_media[:properties])
        Resource.for(social_medium)
      end
    end

    def social_media_icon_for(resource, x_position)
      bounding_box([x_position, cursor], width: resource.width) do
        image(
          resource.image,
          fit: resource.fit,
          align: resource.align
        )
        move_up 35
        transparent_link(resource)
      end
    end

    def organisation_logo_for(entry, logo, start_point = 40)
      organisation_logo = entry[:logos][logo]
      resource = logo_resource(entry, organisation_logo)
      move_up start_point
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image, fit: resource.fit, align: resource.align
        move_up resource.move_up
        transparent_link(resource)
      end
    end

    def logo_resource(entry, logo)
      logo.merge!(at: entry[:at])
      Resource.for(logo)
    end
  end
end