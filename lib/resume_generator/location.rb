require 'decodable'

module ResumeGenerator
  class Location
    extend Decodable

    LOCATIONS = {
      rc: 'U3lkbmV5LCBBdXN0cmFsaWE=',
      fl: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
      gw: 'VG9reW8sIEphcGFu',
      rnt: 'VG9reW8sIEphcGFu',
      sra: 'VG9reW8sIEphcGFu',
      jet: 'S29jaGksIEphcGFu',
      satc: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
      mit: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
      bib: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
      ryu: 'S3lvdG8sIEphcGFu',
      tafe: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ=='
    }

    def self.for(position)
      d(LOCATIONS.fetch(:"#{position}"))
    end
  end
end