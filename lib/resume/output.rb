require_relative 'colours'

module Resume
  class Output
    extend Colours

    def self.messages(messages)
      messages.each { |type, key| public_send(key, type) }
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

    def self.raw(key)
      puts key # aka the message
    end
  end
end
