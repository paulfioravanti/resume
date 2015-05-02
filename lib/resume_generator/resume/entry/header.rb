module ResumeGenerator
  module Resume
    module Entry
      class Header
        include Decoder

        attr_reader :pdf, :position, :organisation,
                    :period, :location, :at_x_position

        def self.generate(pdf, data)
          new(
            pdf,
            data[:position],
            data[:organisation],
            data[:period],
            data[:location],
            data[:at_x_position]
          ).generate
        end


        def generate
          # Different rendering behaviour needed depending on whether the header
          # is being drawn from left to right on the page or specifically placed
          # at a location on the x-axis
          if at_x_position
            formatted_text_box_header
          else
            formatted_text_header
          end
        end

        private

        def initialize(pdf, position, organisation, period, location, at_x_position)
          @pdf = pdf
          @position = position
          @organisation = organisation
          @period = period
          @location = location
          @at_x_position = at_x_position
        end

        def formatted_text_header
          pdf.formatted_text([properties_for(position)])
          pdf.formatted_text([properties_for(organisation)])
          pdf.formatted_text([
            properties_for(period),
            properties_for(location)
          ])
        end

        def formatted_text_box_header
          [position, organisation].each do |section|
            pdf.formatted_text_box(
              [properties_for(section)],
              at: [at_x_position, pdf.cursor]
            )
            pdf.move_down section[:bottom_padding]
          end
          # pdf.formatted_text_box(
          #   [properties_for(position)],
          #   at: [at_x_position, pdf.cursor]
          # )
          # pdf.move_down position[:bottom_padding]
          # pdf.formatted_text_box(
          #   [properties_for(organisation)],
          #   at: [at_x_position, pdf.cursor]
          # )
          # pdf.move_down organisation[:bottom_padding]
          pdf.formatted_text_box(
            [properties_for(period), properties_for(location)],
            at: [at_x_position, pdf.cursor]
          )
        end

        def properties_for(section)
          {
            text: d(section[:text]),
            styles: section[:styles].map(&:to_sym),
            size: section[:size],
            color: section[:colour],
            link: d(section[:link]),
          }
        end
      end
    end
  end
end

