require_relative 'entry/formatted_text_entry'
require_relative 'entry/formatted_text_box_entry'

module ResumeGenerator
  module Resume
    class Header

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

      def initialize(pdf, position, organisation, period, location, at_x_position)
        @pdf = pdf
        @position = position
        @organisation = organisation
        @period = period
        @location = location
        @at_x_position = at_x_position
        # Different rendering behaviour needed depending on whether the header is
        # being drawn from left to right on the page or specifically placed at
        # a location
        if at_x_position
          extend FormattedTextBoxEntry
        else
          extend FormattedTextEntry
        end
      end

      def generate
        generate_position
        generate_organisation
        generate_period_and_location
      end
    end
  end
end

