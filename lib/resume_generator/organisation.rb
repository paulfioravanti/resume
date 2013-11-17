# require 'decodable'

# module ResumeGenerator
#   class Organisation
#     extend Decodable

#     NAMES = {
#       gw: '',
#       rnt: 'UmlnaHQgTm93IFRlY2hub2xvZ2llcw==',
#       sra: 'U29mdHdhcmUgUmVzZWFyY2ggQXNzb2NpYXRlcyAoU1JBKQ==',
#       jet: 'SmFwYW4gRXhjaGFuZ2UgYW5kIFRlYWNoaW5nIFByb2dyYW1tZSAoSkVUKQ==',
#       satc: 'U291dGggQXVzdHJhbGlhbiBUb3VyaXNtIENvbW1pc3Npb24=',
#       mit: 'VW5pdmVyc2l0eSBvZiBTb3V0aCBBdXN0cmFsaWE=',
#       bib: 'RmxpbmRlcnMgVW5pdmVyc2l0eQ==',
#       ryu: 'Unl1a29rdSBVbml2ZXJzaXR5',
#       tafe: 'QWRlbGFpZGUgVEFGRQ=='
#     }

#     def self.for(name)
#       d(NAMES.fetch(:"#{name}"))
#     end
#   end
# end