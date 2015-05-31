module Resume
  module PDF
    module Entry
      class Header
        include Decoder

        attr_reader :pdf, :position, :organisation,
                    :period, :location, :at_x_position

        def self.generate(pdf, entry)
          new(
            pdf,
            entry[:position],
            entry[:organisation],
            entry[:period],
            entry[:location],
            at_x_position: entry[:at_x_position]
          ).generate
        end

        private_class_method :new

        def initialize(pdf, position, organisation, period, location, options)
          @pdf = pdf
          @position = position
          @organisation = organisation
          @period = period
          @location = location
          options.each do |attribute, value|
            instance_variable_set("@#{attribute}", value)
          end
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

        def formatted_text_header
          header_sections.each do |sections|
            pdf.formatted_text(
              sections.map { |section| properties_for(section) }
            )
          end
        end

        def formatted_text_box_header
          header_sections.each do |sections|
            pdf.formatted_text_box(
              sections.map { |section| properties_for(section) },
              at: [at_x_position, pdf.cursor]
            )
            pdf.move_down sections.first[:bottom_padding]
          end
        end

        def header_sections
          [[position], [organisation], [period, location]]
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

