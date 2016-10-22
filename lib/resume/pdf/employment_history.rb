require_relative "entry/heading"
require_relative "entry/content"

module Resume
  module PDF
    module EmploymentHistory
      module_function

      def generate(pdf, employment_history)
        Entry::Heading.generate(pdf, employment_history[:heading])
        content = employment_history[:content]
        content[:entries].values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
        pdf.move_down content[:bottom_padding]
        pdf.stroke_horizontal_rule { color content[:horizontal_rule_colour] }
      end
    end
  end
end
