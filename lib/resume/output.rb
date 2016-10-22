require_relative "colours"

module Resume
  module Output
    module_function

    def messages(messages)
      messages.each { |type, key| public_send(type, key) }
    end

    def error(key)
      puts Colours.red(I18n.translate(*key))
    end

    def warning(key)
      puts Colours.yellow(I18n.translate(*key))
    end

    def question(key)
      print Colours.yellow(I18n.translate(*key))
    end

    def success(key)
      puts Colours.green(I18n.translate(*key))
    end

    def info(key)
      puts Colours.cyan(I18n.translate(*key))
    end

    def plain(key)
      puts I18n.translate(*key)
    end

    def raw_error(message)
      puts Colours.red(message)
    end

    def raw_warning(message)
      puts Colours.yellow(message)
    end

    def raw_success(message)
      puts Colours.green(message)
    end

    def raw(message)
      puts message
    end
  end
end
