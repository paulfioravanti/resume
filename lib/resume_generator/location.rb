# require 'decodable'

# module ResumeGenerator
#   class Location
#     extend Decodable

#     LOCATIONS = {
#       bib: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ==',
#       ryu: 'S3lvdG8sIEphcGFu',
#       tafe: 'QWRlbGFpZGUsIEF1c3RyYWxpYQ=='
#     }

#     def self.for(position)
#       d(LOCATIONS.fetch(:"#{position}"))
#     end
#   end
# end