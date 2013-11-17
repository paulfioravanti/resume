# require 'decodable'

# module ResumeGenerator
#   class Organisation
#     extend Decodable

#     NAMES = {
#       mit: '',
#       bib: 'RmxpbmRlcnMgVW5pdmVyc2l0eQ==',
#       ryu: 'Unl1a29rdSBVbml2ZXJzaXR5',
#       tafe: 'QWRlbGFpZGUgVEFGRQ=='
#     }

#     def self.for(name)
#       d(NAMES.fetch(:"#{name}"))
#     end
#   end
# end