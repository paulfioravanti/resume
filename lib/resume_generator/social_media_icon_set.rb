require 'utilities'

module ResumeGenerator
  class SocialMediaIconSet
    include Utilities

    attr_accessor :x_position
    attr_reader :pdf, :data

    def self.generate(pdf, data)
      new(pdf, data).generate
    end

    def initialize(pdf, data)
      @pdf = pdf
      @data = data
      @x_position = data[:left_padding]
    end

    def generate
      pdf.move_down data[:top_padding]
      resources = social_media_resources
      social_media_icon_for(resources.first)
      resources[1..-1].each do |resource|
        pdf.move_up data[:padded_icon_height]
        social_media_icon_for(resource)
      end
      pdf.stroke_horizontal_rule { color data[:horizontal_rule_colour] }
    end

    private

    def social_media_resources
      data[:resources].values.map do |social_medium|
        ImageLink.for(social_medium.merge(data[:icon_properties]))
      end
    end

    def social_media_icon_for(resource)
      pdf.bounding_box([x_position, pdf.cursor], width: resource.width) do
        pdf.image(resource.image, fit: resource.fit, align: resource.align)
        pdf.move_up resource.link_overlay_start
        transparent_link(pdf, resource)
      end
      self.x_position += data[:padded_icon_width]
    end
  end
end
