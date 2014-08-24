require 'utilities'

module ResumeGenerator
  module Sociable
    include Utilities

    private

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
  end
end