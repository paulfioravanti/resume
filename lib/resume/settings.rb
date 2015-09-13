require_relative '../i18n/core_ext'
require_relative 'file_fetcher'
require_relative 'exceptions'
require_relative 'exception_suppressor'

module Resume
  class Settings
    extend ExceptionSuppressor

    def self.configure
      # Ignore requiring gems that are used just for development
      suppress(LoadError) do
        require 'pry-byebug'
      end
      configure_i18n
    end

    def self.configure_i18n
      require 'i18n'
      require 'i18n/backend'
      require 'i18n/backend/base'
      I18n.available_locales = [:en, :it, :ja]
      I18n.available_locales.each do |locale|
        I18n.load_path += [
          FileFetcher.fetch(
            "lib/resume/locales/#{locale}.yml.erb", mode: 'w'
          )
        ]
      end
    rescue LoadError
      raise DependencyPrerequisiteError
    end
    private_class_method :configure_i18n
  end
end
