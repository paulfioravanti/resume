require_relative "image_link"

module Resume
  module PDF
    # Module for generating a social media logo set to display
    # at the top of the resume.
    #
    # @author Paul Fioravanti
    module SocialMediaLogoSet
      module_function

      # Generates a social media logo set on the resume.
      #
      # @param pdf [Prawn::Document]
      #   The PDF to on which to apply the social media logo set.
      # @param logo_set [Hash]
      #   Presentation information about the set of logos.
      def generate(pdf, logo_set)
        top_padding, horizontal_rule_colour =
          logo_set.values_at(:top_padding, :horizontal_rule_colour)
        pdf.move_down(top_padding)
        generate_logos(pdf, logo_set)
        pdf.stroke_horizontal_rule { color(horizontal_rule_colour) }
      end

      def generate_logos(pdf, logo_set)
        logos = entire_logo_properties(logo_set)
        generate_logo_for(logos.first, pdf, logo_set)
        generate_logos_for(logos[1..-1], pdf, logo_set)
        pdf.move_down(logo_set[:bottom_padding])
      end
      private_class_method :generate_logos

      def entire_logo_properties(logo_set)
        logo_set[:logos].values.map do |values|
          values.merge(logo_set[:logo_properties])
        end
      end
      private_class_method :entire_logo_properties

      def generate_logo_for(logo, pdf, logo_set)
        x_position = logo_set[:x_position]
        pdf.bounding_box([x_position, pdf.cursor], width: logo[:width]) do
          ImageLink.generate(pdf, logo)
        end
        # Slightly cheating by keeping state in the logo set hash
        logo_set[:x_position] = x_position + logo_set[:padded_logo_width]
      end
      private_class_method :generate_logo_for

      def generate_logos_for(logos, pdf, logo_set)
        logos.each do |logo|
          pdf.move_up(logo_set[:padded_logo_height])
          generate_logo_for(logo, pdf, logo_set)
        end
      end
      private_class_method :generate_logos
    end
  end
end
