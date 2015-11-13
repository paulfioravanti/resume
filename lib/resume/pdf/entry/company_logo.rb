module Resume
  module PDF
    module Entry
      class CompanyLogo
        extend TransparentLink

        def self.generate(pdf, logo)
          pdf.move_up logo[:y_start]
          pdf.bounding_box(
            [logo[:origin], pdf.cursor],
            width: logo[:width], height: logo[:height]) do
            render_image_link(pdf, logo)
          end
        end

        def self.render_image_link(pdf, logo)
          pdf.image(logo[:image], fit: logo[:fit], align: logo[:align])
          pdf.move_up logo[:link_overlay_start]
          transparent_link(pdf, logo)
        end
        private_class_method :render_image_link
      end
    end
  end
end
