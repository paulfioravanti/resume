# require 'decodable'

# module ResumeGenerator
#   class Period
#     extend Decodable

#     PERIODS = {
#       mit: '',
#       bib: 'MTk5Ny0xOTk5IHw=',
#       ryu: 'U2VwIDE5OTkgLSBGZWIgMjAwMCB8',
#       tafe: 'TWF5IDIwMDAgLSBNYXkgMjAwMSB8'
#     }

#     def self.for(position)
#       d(PERIODS.fetch(:"#{position}"))
#     end
#   end
# end