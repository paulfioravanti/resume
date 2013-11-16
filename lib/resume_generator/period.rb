# require 'decodable'

# module ResumeGenerator
#   class Period
#     extend Decodable

#     PERIODS = {
#       gw: 'SmFudWFyeSAyMDA5IOKAkyBTZXB0ZW1iZXIgMjAxMSB8ICA=',
#       rnt: 'SnVseSAyMDA3IOKAkyBBdWd1c3QgMjAwOCB8ICA=',
#       sra: 'QXByaWwgMjAwNiDigJMgSnVuZSAyMDA3IHwgIA==',
#       jet: 'SnVseSAyMDAxIOKAkyBKdWx5IDIwMDQgfCAg',
#       satc: 'TWF5IDIwMDAg4oCTIE1heSAyMDAxIHwgIA==',
#       mit: 'MjAwNC0yMDA1IHw=',
#       bib: 'MTk5Ny0xOTk5IHw=',
#       ryu: 'U2VwIDE5OTkgLSBGZWIgMjAwMCB8',
#       tafe: 'TWF5IDIwMDAgLSBNYXkgMjAwMSB8'
#     }

#     def self.for(position)
#       d(PERIODS.fetch(:"#{position}"))
#     end
#   end
# end