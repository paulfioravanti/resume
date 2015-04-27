module ResumeGenerator
  module Resume
    module FormattedTextEntry
      include Decoder

      private

      def generate_position
        pdf.formatted_text([{
          text: d(position[:text]),
          styles: position[:styles].map(&:to_sym),
          size: position[:size]
        }])
      end

      def generate_organisation
        pdf.formatted_text([{
          text: d(organisation[:text]),
          styles: organisation[:styles].map(&:to_sym),
          size: organisation[:size]
        }])
      end

      def generate_period_and_location
        pdf.formatted_text([
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
        ])
      end
    end
  end
end

