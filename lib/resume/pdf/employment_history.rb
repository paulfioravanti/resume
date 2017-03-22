require_relative "entry/heading"
require_relative "entry/content"

module Resume
  module PDF
    module EmploymentHistory
      module_function

      def generate(pdf, employment_history)
        Entry::Heading.generate(pdf, employment_history[:heading])
        entries, bottom_padding, horizontal_rule_colour =
          employment_history[:content].values_at(
            :entries, :bottom_padding, :horizontal_rule_colour
          )
        generate_content(pdf, entries)
        footer(pdf, bottom_padding, horizontal_rule_colour)
      end

      def generate_content(pdf, entries)
        entries.values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
      end
      private_class_method :generate_content

      def footer(pdf, bottom_padding, horizontal_rule_colour)
        pdf.move_down(bottom_padding)
        pdf.stroke_horizontal_rule { color(horizontal_rule_colour) }
      end
      private_class_method :footer
    end
  end
end
