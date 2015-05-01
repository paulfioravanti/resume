require_relative 'utilities'
require_relative 'image_link'

module ResumeGenerator
  module Resume
    class SocialMediaIconSet
      include Utilities

      attr_reader :pdf, :x_position, :top_padding, :padded_icon_width,
                  :padded_icon_height, :horizontal_rule_colour, :icons,
                  :icon_properties
      attr_accessor :x_position

      def self.generate(pdf, icon_set)
        new(pdf, icon_set).generate
      end

      def initialize(pdf, icon_set)
        @pdf = pdf
        @x_position = icon_set[:x_position]
        @top_padding = icon_set[:top_padding]
        @padded_icon_width = icon_set[:padded_icon_width]
        @padded_icon_height = icon_set[:padded_icon_height]
        @horizontal_rule_colour = icon_set[:horizontal_rule_colour]
        @icons = icon_set[:icons]
        @icon_properties = icon_set[:icon_properties]
      end

      def generate
        pdf.move_down(top_padding)
        image_links = social_media_image_links
        generate_social_media_icon_for(image_links.first)
        image_links[1..-1].each do |image_link|
          pdf.move_up(padded_icon_height)
          generate_social_media_icon_for(image_link)
        end
        pdf.stroke_horizontal_rule { color horizontal_rule_colour }
      end

      private

      def social_media_image_links
        icons.values.map do |icon|
          ImageLink.for(icon.merge(icon_properties))
        end
      end

      def generate_social_media_icon_for(image_link)
        pdf.bounding_box([x_position, pdf.cursor], width: image_link.width) do
          pdf.image(
            image_link.image,
            fit: image_link.fit,
            align: image_link.align
          )
          pdf.move_up image_link.link_overlay_start
          transparent_link(pdf, image_link)
        end
        self.x_position += padded_icon_width
      end
    end
  end
end

