require_relative '../i18n/core_ext'
require_relative 'file_fetcher'
require_relative 'exceptions'

module Resume
  class Settings
    def self.configure
      configure_development_dependencies
      configure_i18n
    end

    def self.configure_development_dependencies
      require 'pry-byebug'
    rescue LoadError
      # Ignore requiring gems that are just used for development
    end
    private_class_method :configure_development_dependencies

    def self.configure_i18n
      require 'i18n'
      require 'i18n/backend'
      require 'i18n/backend/base'
      I18n.available_locales = [:en, :ja]
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
