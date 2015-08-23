module Resume
  class Error < StandardError
    attr_reader :messages
  end

  class DependencyPrerequisiteError < Error
    def initialize
      @messages = {
        raw_error:
          'My resume and the specs are bilingual and need the I18n gem.',
        raw_warning: 'Please run: gem install i18n'
      }
    end
  end

  class NetworkConnectionError < Error
    def initialize
      @messages = {
        error: :cant_connect_to_the_internet,
        warning: :please_check_your_network_settings
      }
    end
  end
end
