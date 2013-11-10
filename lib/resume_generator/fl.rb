require 'link'
require 'logo'

module ResumeGenerator
  class FL
    attr_reader :ruby_logo, :rails_logo, :location_link

    def initialize
      @ruby_logo =
        Logo.new(
          organisation: 'ruby',
          origin: 440,
          width: 37,
          height: 33,
          fit: [31, 31],
          move_up: 30,
          bars: 4,
          size: 34
        )
      @rails_logo =
        Logo.new(
          organisation: 'rails',
          origin: 480,
          width: 32,
          height: 34,
          fit: [31, 31],
          move_up: 30,
          bars: 3,
          size: 35
        )
      # @location_link = Link.for('rc_location')
      @location_link = 'fl_location'
    end

    def position
      'UnVieSBEZXZlbG9wZXI='
    end

    def organisation
      'RnJlZWxhbmNl'
    end

    def period
      'U2VwdGVtYmVyIDIwMTIg4oCTIEp1bHkgMjAxMyB8ICA='
    end

    def location
      'QWRlbGFpZGUsIEF1c3RyYWxpYQ=='
    end
  end
end