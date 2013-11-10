module ResumeGenerator
  class Logo
    LOGO_CONFIG = {
      rc: ['rc', 415, 115, 40, [110, 40], 40, 10, 43],
      ruby: ['ruby', 440, 37, 33, [31, 31], 30, 4, 34],
      rails: ['rails', 480, 32, 34, [31, 31], 30, 3, 35]
    }

    KEYS = %i(organisation origin width height fit move_up bars size)

    def self.for(position)
      values = LOGO_CONFIG.fetch(:"#{position}")
      Hash[KEYS.zip(values)]
    end
  end
end
