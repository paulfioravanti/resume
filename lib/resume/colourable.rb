module Resume
  module Colourable
    private

    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def red(text)
      colorize(text, 31)
    end

    def yellow(text)
      colorize(text, 33)
    end

    def green(text)
      colorize(text, 32)
    end

    def cyan(text)
      colorize(text, 36)
    end
  end
end