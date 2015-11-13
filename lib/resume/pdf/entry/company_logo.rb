module Resume
  module PDF
    module Entry
      class CompanyLogo
        include TransparentLink

        def self.generate(pdf, logo)
          new(pdf, logo).generate
        end

        private_class_method :new

        def initialize(pdf, logo)
          @pdf = pdf
          @logo = logo
        end

        def generate
          pdf.move_up logo[:y_start]
          pdf.bounding_box(
            [logo[:origin], pdf.cursor],
            width: logo[:width], height: logo[:height]) do
            render_image_link
          end
        end

        private

        attr_reader :pdf, :logo

        def render_image_link
          pdf.image(logo[:image], fit: logo[:fit], align: logo[:align])
          pdf.move_up logo[:link_overlay_start]
          transparent_link(pdf, logo)
        end
      end
    end
  end
end
