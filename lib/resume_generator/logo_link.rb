require 'resource'
require 'utilities'

module ResumeGenerator
  class LogoLink
    include Utilities

    attr_reader :pdf, :logo, :y_logo_start

    def self.generate(pdf, data)
      new(pdf, data).generate
    end

    def initialize(pdf, data)
      @pdf = pdf
      @logo = Resource.for(data[:logo].merge(at: data[:at]))
      @y_logo_start = data[:y_logo_start] || 40
    end

    def generate
      pdf.move_up y_logo_start
      pdf.bounding_box([logo.origin, pdf.cursor],
        width: logo.width, height: logo.height) do
        pdf.image(logo.image, fit: logo.fit, align: logo.align)
        pdf.move_up logo.move_up
        transparent_link(pdf, logo)
      end
    end
  end
end
