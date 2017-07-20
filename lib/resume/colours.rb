module Resume
  # Module representing CLI colour output.
  #
  # @author Paul Fioravanti
  module Colours
    # Terminal colour cyan
    CYAN = 36
    private_constant :CYAN
    # Terminal colour green
    GREEN = 32
    private_constant :GREEN
    # Terminal colour red
    RED = 31
    private_constant :RED
    # Terminal colour yellow
    YELLOW = 33
    private_constant :YELLOW

    module_function

    # Wraps `text` in ASCII escape codes for red text.
    #
    # @param text [String] the text to output
    # @return [String] the colour ASCII-escaped string
    def red(text)
      colourize(text, colour_code: RED)
    end

    # Wraps `text` in ASCII escape codes for green text.
    #
    # @param (see #red)
    # @return (see #red)
    def green(text)
      colourize(text, colour_code: GREEN)
    end

    # Wraps `text` in ASCII escape codes for yellow text.
    #
    # @param (see #red)
    # @return (see #red)
    def yellow(text)
      colourize(text, colour_code: YELLOW)
    end

    # Wraps `text` in ASCII escape codes for cyan text.
    #
    # @param (see #red)
    # @return (see #red)
    def cyan(text)
      colourize(text, colour_code: CYAN)
    end

    def colourize(text, colour_code:)
      "\e[#{colour_code}m#{text}\e[0m"
    end
    private_class_method :colourize
  end
end
