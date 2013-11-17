# require 'resource'

# module ResumeGenerator
#   class Logo
#     LOGO_CONFIG = {
#       bib:   [Resource.for('bib'), 490, 35, 40, [35, 40], 40, 3, 43],
#       ryu:   [Resource.for('ryu'), 214, 32, 40, [32, 40], 40, 3, 40],
#       tafe:  [Resource.for('tafe'), 490, 37, 35, [37, 35], 19, 5, 28]
#     }

#     KEYS = [:resource, :origin, :width, :height, :fit, :move_up, :bars, :size]

#     def self.for(organisation)
#       values = LOGO_CONFIG.fetch(:"#{organisation}")
#       Hash[KEYS.zip(values)]
#     end
#   end
# end
