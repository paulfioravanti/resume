require_relative 'exceptions'
require_relative 'output'

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
      require_relative '../i18n/core_ext'
      I18n.load_path =
        Dir["#{Pathname(__FILE__).dirname}/locales/*.yml.erb"]
      I18n.available_locales = [:en, :ja]
    rescue LoadError
      raise DependencyPrerequisiteError
    end
    private_class_method :configure_i18n
  end
end
