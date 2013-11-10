require 'link'
require 'logo'

module ResumeGenerator
  class RC
    attr_reader :logo, :location_link

    def initialize
      @logo =
        Logo.new(
          organisation: 'rc',
          origin: 415,
          width: 115,
          height: 40,
          fit: [110, 40],
          move_up: 40,
          bars: 10,
          size: 43
        )
      # @location_link = Link.for('rc_location')
      @location_link = 'rc_location'
    end

    def position
      'U2VuaW9yIERldmVsb3Blcg=='
    end

    def organisation
      'UmF0ZUNpdHkuY29tLmF1'
    end

    def period
      'SnVseSAyMDEzIC0gUHJlc2VudCB8'
    end

    def location
      'U3lkbmV5LCBBdXN0cmFsaWE='
    end
  end
end