require 'resource'

module ResumeGenerator
  class SocialMediaIconSet
    attr_accessor :x_position
    attr_reader :pdf, :data

    def self.generate(pdf, data)
      new(pdf, data).generate
    end

    def initialize(pdf, data)
      @pdf = pdf
      @data = data
      @x_position = 0
    end

    def generate
      resources = social_media_resources
      social_media_icon_for(resources.first)
      resources[1..-1].each do |resource|
        pdf.move_up 46.25
        social_media_icon_for(resource)
      end
    end

    private

    def social_media_resources
      data[:resources].values.map do |social_medium|
        Resource.for(social_medium.merge(data[:properties]))
      end
    end

    def social_media_icon_for(resource)
      pdf.bounding_box([x_position, pdf.cursor], width: resource.width) do
        pdf.image(resource.image, fit: resource.fit, align: resource.align)
        pdf.move_up 35
        transparent_link(resource)
      end
      self.x_position += 45
    end

    def transparent_link(resource)
      pdf.transparent(0) do
        pdf.formatted_text(
          [
            {
              text: '|' * resource.bars,
              size: resource.size,
              link: resource.link
            }
          ], align: resource.align
        )
      end
    end
  end
end
