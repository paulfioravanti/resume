module Resume
  # Module representing CLI colour output.
  #
  # @author Paul Fioravanti
  module Colours
    module_function

    # Wraps `text` in ASCII escape codes for red text.
    #
    # @param text [String] the text to output
    # @return [String] the colour ASCII-escaped string
    def red(text)
      colourize(text, colour_code: 31)
    end

    # Wraps `text` in ASCII escape codes for green text.
    #
    # @param (see #red)
    # @return (see #red)
    def green(text)
      colourize(text, colour_code: 32)
    end

    # Wraps `text` in ASCII escape codes for yellow text.
    #
    # @param (see #red)
    # @return (see #red)
    def yellow(text)
      colourize(text, colour_code: 33)
    end

    # Wraps `text` in ASCII escape codes for cyan text.
    #
    # @param (see #red)
    # @return (see #red)
    def cyan(text)
      colourize(text, colour_code: 36)
    end

    def colourize(text, colour_code:)
      "\e[#{colour_code}m#{text}\e[0m"
    end
    private_class_method :colourize
  end
end
