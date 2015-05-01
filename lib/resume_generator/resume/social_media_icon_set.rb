require_relative 'utilities'
require_relative 'image_link'

module ResumeGenerator
  module Resume
    class SocialMediaIconSet
      include Utilities

      attr_reader :pdf, :icon_set
      attr_accessor :x_position

      def self.generate(pdf, icon_set)
        new(pdf, icon_set).generate
      end

      def initialize(pdf, icon_set)
        @pdf = pdf
        @icon_set = icon_set
        @x_position = icon_set[:left_padding]
      end

      def generate
        pdf.move_down icon_set[:top_padding]
        resources = social_media_resources
        social_media_icon_for(resources.first)
        resources[1..-1].each do |resource|
          pdf.move_up icon_set[:padded_icon_height]
          social_media_icon_for(resource)
        end
        pdf.stroke_horizontal_rule { color icon_set[:horizontal_rule_colour] }
      end

      private

      def social_media_resources
        icon_set[:icons].values.map do |social_medium|
          ImageLink.for(social_medium.merge(icon_set[:icon_properties]))
        end
      end

      def social_media_icon_for(resource)
        pdf.bounding_box([x_position, pdf.cursor], width: resource.width) do
          pdf.image(resource.image, fit: resource.fit, align: resource.align)
          pdf.move_up resource.link_overlay_start
          transparent_link(pdf, resource)
        end
        self.x_position += icon_set[:padded_icon_width]
      end
    end
  end
end

