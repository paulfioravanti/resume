module ResumeGenerator
  module Colourable
    private

    def colourize(text, colour_code)
      "\e[#{colour_code}m#{text}\e[0m"
    end

    def red(text)
      colourize(text, 31)
    end

    def yellow(text)
      colourize(text, 33)
    end

    def green(text)
      colourize(text, 32)
    end

    def cyan(text)
      colourize(text, 36)
    end
  end
end
