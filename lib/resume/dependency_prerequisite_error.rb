module Resume
  class DependencyPrerequisiteError < StandardError
    attr_reader :messages

    def initialize
      @messages = {
        raw_error:
          'My resume and the specs are bilingual and need the I18n gem.',
        raw_warning: 'Please run: gem install i18n'
      }
    end
  end
end
