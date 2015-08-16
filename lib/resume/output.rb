require_relative 'colours'

module Resume
  class Output
    include Colours

    def self.message(messages)
      messages.each { |m| new(*m).message }
    end

    private_class_method :new

    def initialize(type, key)
      @type = type
      @key = key
    end

    def message
      send(type)
    end

    private

    attr_reader :type, :key

    def error
      puts red(I18n.t(*key))
    end

    def warning
      puts yellow(I18n.t(*key))
    end

    def question
      print yellow(I18n.t(*key))
    end

    def success
      puts green(I18n.t(*key))
    end

    def thanks
      puts cyan(I18n.t(*key))
    end

    def info
      puts I18n.t(*key)
    end

    def raw
      puts key # aka the message
    end
  end
end
