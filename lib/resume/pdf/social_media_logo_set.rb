require_relative 'transparent_link'

module Resume
  module PDF
    class SocialMediaLogoSet
      extend TransparentLink

      def self.generate(pdf, logo_set)
        pdf.move_down(logo_set[:top_padding])
        generate_logos(pdf, logo_set)
        pdf.move_down(logo_set[:bottom_padding])
        pdf.stroke_horizontal_rule { color logo_set[:horizontal_rule_colour] }
      end

      def self.generate_logos(pdf, logo_set)
        logos = entire_logo_properties(logo_set)
        generate_logo_for(logos.first, pdf, logo_set)
        logos[1..-1].each do |logo|
          pdf.move_up(logo_set[:padded_logo_height])
          generate_logo_for(logo, pdf, logo_set)
        end
      end
      private_class_method :generate_logos

      def self.entire_logo_properties(logo_set)
        logo_set[:logos].values.map do |values|
          values.merge(logo_set[:logo_properties])
        end
      end
      private_class_method :entire_logo_properties

      def self.generate_logo_for(logo, pdf, logo_set)
        x_position = logo_set[:x_position]
        pdf.bounding_box(
          [x_position, pdf.cursor], width: logo[:width]) do
          pdf.image(logo[:image], fit: logo[:fit], align: logo[:align])
          pdf.move_up logo[:link_overlay_start]
          transparent_link(pdf, logo)
        end
        # Slightly cheating by keeping state in the logo set hash
        logo_set[:x_position] =
          x_position + logo_set[:padded_logo_width]
      end
      private_class_method :generate_logo_for
    end
  end
end
