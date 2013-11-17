module ResumeGenerator
  module SocialMediaHelper
    def social_media_icons
      move_down 5
      resources = social_media_resources
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

    # def social_media_resources
    #   properties = RESUME[:social_media][:properties]
    #   RESUME[:social_media][:resources].values.map do |social_medium|
    #     social_medium.merge!(properties)
    #     Resource.for(social_medium)
    #   end
    # end

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