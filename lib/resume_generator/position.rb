# require 'decodable'

# module ResumeGenerator
#   class Position
#     extend Decodable

#     NAMES = {
#       gw: '',
#       rnt: '',
#       sra: '',
#       jet: '',
#       satc: "SW50ZXJuYXRpb25hbCBNYXJrZXRpbmcgQXNzaXN0YW50IOKAkyBBc2lhIGFu"\
#               "ZCBKYXBhbg==",
#       mit: 'TWFzdGVycyBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5',
#       bib: 'QmFjaGVsb3Igb2YgSW50ZXJuYXRpb25hbCBCdXNpbmVzcw==',
#       ryu: 'U3R1ZGVudCBFeGNoYW5nZSBQcm9ncmFtbWU=',
#       tafe: 'Q2VydGlmaWNhdGUgSUkgaW4gVG91cmlzbQ=='
#     }

#     def self.for(organisation)
#       d(NAMES.fetch(:"#{organisation}"))
#     end
#   end
# end