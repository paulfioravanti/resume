module ResumeGenerator
  class Logo
    LOGO_CONFIG = {
      rc: [Resource.for('rc'), 415, 115, 40, [110, 40], 40, 10, 43],
      ruby: [Resource.for('ruby'), 440, 37, 33, [31, 31], 30, 4, 34],
      rails: [Resource.for('rails'), 480, 32, 34, [31, 31], 30, 3, 35]
    }

    KEYS = %i(resource origin width height fit move_up bars size)

    def self.for(organisation)
      values = LOGO_CONFIG.fetch(:"#{organisation}")
      Hash[KEYS.zip(values)]
    end
  end
end
