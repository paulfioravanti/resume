require_relative 'colours'

module Resume
  class Output
    extend Colours

    def self.messages(messages)
      messages.each { |type, key| public_send(type, key) }
    end

    def self.error(key)
      puts red(I18n.t(*key))
    end

    def self.warning(key)
      puts yellow(I18n.t(*key))
    end

    def self.question(key)
      print yellow(I18n.t(*key))
    end

    def self.success(key)
      puts green(I18n.t(*key))
    end

    def self.thanks(key)
      puts cyan(I18n.t(*key))
    end

    def self.info(key)
      puts I18n.t(*key)
    end

    def self.raw(message)
      puts message
    end
  end
end
