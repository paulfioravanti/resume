require_relative 'colours'

module Resume
  class Output
    extend Colours

    def self.messages(messages)
      messages.each { |type, key| public_send(type, key) }
    end

    def self.error(key)
      puts red(I18n.translate(*key))
    end

    def self.warning(key)
      puts yellow(I18n.translate(*key))
    end

    def self.question(key)
      print yellow(I18n.translate(*key))
    end

    def self.success(key)
      puts green(I18n.translate(*key))
    end

    def self.info(key)
      puts cyan(I18n.translate(*key))
    end

    def self.plain(key)
      puts I18n.translate(*key)
    end

    def self.raw_error(message)
      puts red(message)
    end

    def self.raw_warning(message)
      puts yellow(message)
    end

    def self.raw_success(message)
      puts green(message)
    end

    def self.raw(message)
      puts message
    end
  end
end
