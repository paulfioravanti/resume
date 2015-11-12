module Resume
  module Colours
    def self.extended(base)
      instance_methods(false).each do |method|
        base.send(:private_class_method, method)
      end
    end

    def red(text)
      colourize(text, colour_code: 31)
    end

    def green(text)
      colourize(text, colour_code: 32)
    end

    def yellow(text)
      colourize(text, colour_code: 33)
    end

    def cyan(text)
      colourize(text, colour_code: 36)
    end

    def colourize(text, colour_code:)
      "\e[#{colour_code}m#{text}\e[0m"
    end
  end
end
