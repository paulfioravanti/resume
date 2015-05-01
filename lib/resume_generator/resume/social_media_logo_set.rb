require_relative 'utilities'
require_relative 'image_link'

module ResumeGenerator
  module Resume
    class SocialMediaLogoSet
      include Utilities

      attr_reader :pdf, :x_position, :top_padding, :padded_logo_width,
                  :padded_logo_height, :horizontal_rule_colour, :logos,
                  :logo_properties
      attr_accessor :x_position

      def self.generate(pdf, logo_set)
        new(pdf, logo_set).generate
      end

      def initialize(pdf, logo_set)
        @pdf = pdf
        @x_position = logo_set[:x_position]
        @top_padding = logo_set[:top_padding]
        @padded_logo_width = logo_set[:padded_logo_width]
        @padded_logo_height = logo_set[:padded_logo_height]
        @horizontal_rule_colour = logo_set[:horizontal_rule_colour]
        @logos = logo_set[:logos]
        @logo_properties = logo_set[:logo_properties]
      end

      def generate
        pdf.move_down(top_padding)
        logo_links = social_media_logo_links
        generate_social_media_logo_for(logo_links.first)
        logo_links[1..-1].each do |logo_link|
          pdf.move_up(padded_logo_height)
          generate_social_media_logo_for(logo_link)
        end
        pdf.stroke_horizontal_rule { color horizontal_rule_colour }
      end

      private

      def social_media_logo_links
        logos.values.map do |logo|
          ImageLink.for(logo.merge(logo_properties))
        end
      end

      def generate_social_media_logo_for(image_link)
        pdf.bounding_box([x_position, pdf.cursor], width: image_link.width) do
          pdf.image(
            image_link.image,
            fit: image_link.fit,
            align: image_link.align
          )
          pdf.move_up image_link.link_overlay_start
          transparent_link(pdf, image_link)
        end
        self.x_position += padded_logo_width
      end
    end
  end
end

