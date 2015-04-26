module ResumeGenerator
  class LogoLink
    include Utilities

    attr_reader :pdf, :logo, :y_logo_start

    def self.generate(pdf, data)
      logo = ImageLink.for(data[:logo].merge(at: data[:at]))
      y_logo_start = data[:y_logo_start]
      new(pdf, logo, y_logo_start).generate
    end

    def initialize(pdf, logo, y_logo_start)
      @pdf = pdf
      @logo = logo
      @y_logo_start = y_logo_start
    end

    def generate
      move_up(y_logo_start)
      render_logo_link
    end

    private

    def move_up(value)
      pdf.move_up value
    end

    def render_logo_link
      pdf.bounding_box([logo.origin, pdf.cursor],
        width: logo.width, height: logo.height) do
        render_image
        move_up(logo.link_overlay_start)
        transparent_link(pdf, logo)
      end
    end

    def render_image
      pdf.image(logo.image, fit: logo.fit, align: logo.align)
    end
  end
end
