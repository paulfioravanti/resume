module Resume
  module PDF
    module Entry
      module CompanyLogo
        module_function

        def generate(pdf, logo)
          pdf.move_up logo[:y_start]
          pdf.bounding_box(
            [logo[:origin], pdf.cursor],
            width: logo[:width], height: logo[:height]
          ) do
            ImageLink.generate(pdf, logo)
          end
        end
      end
    end
  end
end
