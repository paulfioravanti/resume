module Resume
  VERSION = '0.6'
  DATA_LOCATION = 'resources/'

  begin
    require 'pry-byebug'
  rescue LoadError
    # Ignore requiring gems that are just used for development
  end

  begin
    require 'i18n'
    require_relative 'i18n/core_ext'
    I18n.load_path =
      Dir["#{Pathname(__FILE__).dirname}/resume/cli/locales/*.yml.erb"]
    I18n.available_locales = [:en, :ja]
  rescue LoadError
    puts 'This app is bilingual and needs the I18n gem.'
    puts 'Please run: gem install i18n'
    exit
  end

  def self.filename
    "#{DATA_LOCATION}resume.#{I18n.locale}.json"
  end
end

module I18n
  module Backend
    module Base
      protected

      def load_erb(filename)
        begin
          YAML.load(ERB.new(File.read(filename)).result)
        rescue TypeError, ScriptError, StandardError => e
          raise InvalidLocaleData.new(filename, e.inspect)
        end
      end
    end
  end
end
