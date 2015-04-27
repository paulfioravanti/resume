module ResumeGenerator
  module Resume
    module Entry
      class LogoLink
        include Utilities

        attr_reader :pdf, :logo

        def self.generate(pdf, data)
          logo = ImageLink.for(data[:logo])
          new(pdf, logo).generate
        end

        def initialize(pdf, logo)
          @pdf = pdf
          @logo = logo
        end

        def generate
          pdf.move_up logo.y_start
          pdf.bounding_box(
            [logo.origin, pdf.cursor],
            width: logo.width, height: logo.height
          ) do
            pdf.image(logo.image, fit: logo.fit, align: logo.align)
            pdf.move_up logo.link_overlay_start
            transparent_link(pdf, logo)
          end
        end
      end
    end
  end
end

