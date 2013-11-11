require 'link'
require 'logo'

module ResumeGenerator
  class FL
    attr_reader :ruby_logo, :rails_logo, :location_link

    def initialize
      @ruby_logo = Logo.for('ruby')
      @rails_logo = Logo.for('rails')
      @location_link = Link.for('rc_location')
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