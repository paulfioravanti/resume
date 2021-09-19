require_relative "colours"

module Resume
  # Wrapper module around printing to `$stdout` that can deal with CLI
  # colours and internationalisation.
  #
  # @author Paul Fioravanti
  module Output
    module_function

    # Calls to appropriately output each type of message in the
    # given `messages`.
    #
    # @param messages [Hash]
    #   A hash of messages where the keys describe the type of message to
    #   output, and the values describe the i18n key for the message to ouput.
    # @return [Hash] the original hash of `messages`.
    def messages(messages)
      messages.each { |type, key| public_send(type, key) }
    end

    # Outputs the translated message for `params` to `$stdout` in red
    # with a newline ending.
    #
    # @overload error(key)
    #   @param key [Symbol] The message key to translate
    # @overload error(key, params)
    #   @param key [Symbol] The message key to translate
    #   @param params [Hash] The params to pass in to the translation message
    # @return [nil]
    def error(key, **params)
      puts Colours.red(I18n.translate(key, **params))
    end

    # Outputs the translated message for `params` to `$stdout` in yellow
    # with a newline ending.
    #
    # @overload warning(key)
    #   @param key [Symbol] The message key to translate
    # @overload warning(key, params)
    #   @param key [Symbol] The message key to translate
    #   @param params [Hash] The params to pass in to the translation message
    # @return [nil]
    def warning(key, **params)
      puts Colours.yellow(I18n.translate(key, **params))
    end

    # Outputs the translated message for `params` to `$stdout` in yellow
    # without a newline ending.
    #
    # @overload question(key)
    #   @param key [Symbol] The message key to translate
    # @overload question(key, params)
    #   @param key [Symbol] The message key to translate
    #   @param params [Hash] The params to pass in to the translation message
    # @return [nil]
    def question(key, **params)
      print Colours.yellow(I18n.translate(key, **params))
    end

    # Outputs the translated message for `params` to `$stdout` in green
    # with a newline ending.
    #
    # @overload success(key)
    #   @param key [Symbol] The message key to translate
    # @overload success(key, params)
    #   @param key [Symbol] The message key to translate
    #   @param params [Hash] The params to pass in to the translation message
    # @return [nil]
    def success(key, **params)
      puts Colours.green(I18n.translate(key, **params))
    end

    # Outputs the translated message for `params` to `$stdout` in cyan
    # with a newline ending.
    #
    # @overload info(key)
    #   @param key [Symbol] The message key to translate
    # @overload info(key, params)
    #   @param key [Symbol] The message key to translate
    #   @param params [Hash] The params to pass in to the translation message
    # @return [nil]
    def info(key, **params)
      puts Colours.cyan(I18n.translate(key, **params))
    end

    # Outputs the translated message for `params` to `$stdout` in default
    # colour with a newline ending.
    #
    # @overload plain(key)
    #   @param key [Symbol] The message key to translate
    # @overload plain(key, params)
    #   @param key [Symbol] The message key to translate
    #   @param params [Hash] The params to pass in to the translation message
    # @return [nil]
    def plain(key, **options)
      puts I18n.translate(key, **options)
    end

    # Outputs the `message` parameter to `$stdout` in red
    # with a newline ending.
    #
    # @param (see #raw)
    # @return (see #raw)
    def raw_error(message)
      puts Colours.red(message)
    end

    # Outputs the `message` parameter to `$stdout` in yellow
    # with a newline ending.
    #
    # @param (see #raw)
    # @return (see #raw)
    def raw_warning(message)
      puts Colours.yellow(message)
    end

    # Outputs the `message` parameter to `$stdout` in green
    # with a newline ending.
    #
    # @param (see #raw)
    # @return (see #raw)
    def raw_success(message)
      puts Colours.green(message)
    end

    # Outputs the `message` parameter to `$stdout` in default colour
    # with a newline ending.
    #
    # @param message [String] The message to output
    # @return [nil]
    def raw(message)
      puts message
    end
  end
end
