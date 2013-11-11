require 'link'
require 'logo'

module ResumeGenerator
  class GW
    attr_reader :logo, :location_link

    def initialize
      @logo = Logo.for('gw')
      @location_link = Link.for('gw_location')
    end

    def position
      'UHJlLXNhbGVzIENvbnN1bHRhbnQ='
    end

    def organisation
      'R3VpZGV3aXJlIFNvZnR3YXJl'
    end

    def period
      'SmFudWFyeSAyMDA5IOKAkyBTZXB0ZW1iZXIgMjAxMSB8ICA='
    end

    def location
      'VG9reW8sIEphcGFu'
    end
  end
end