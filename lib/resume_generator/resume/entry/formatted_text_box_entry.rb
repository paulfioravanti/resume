module ResumeGenerator
  module Resume
    module FormattedTextBoxEntry
      include Decoder

      private

      def generate_position
        pdf.formatted_text_box(
          [{
            text: d(position[:text]),
            styles: position[:styles].map(&:to_sym),
            size: position[:size]
          }],
          at: [at_x_position, pdf.cursor]
        )
        pdf.move_down position[:bottom_padding]
      end

      def generate_organisation
        pdf.formatted_text_box(
          [{
            text: d(organisation[:text]),
            styles: organisation[:styles].map(&:to_sym),
            size: organisation[:size]
          }],
          at: [at_x_position, pdf.cursor]
        )
        pdf.move_down organisation[:bottom_padding]
      end

      def generate_period_and_location
        pdf.formatted_text_box(
          [
            {
              text: d(period[:text]),
              color: period[:colour],
              size: period[:size]
            },
            {
              text: d(location[:text]),
              link: d(location[:link]),
              color: location[:colour],
              size: location[:size]
            }
          ],
          at: [at_x_position, pdf.cursor]
        )
      end
    end
  end
end

