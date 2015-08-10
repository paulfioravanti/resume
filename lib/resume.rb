module Resume
  VERSION = '0.6'

  begin
    require 'pry-byebug'
  rescue LoadError
    # Ignore requiring gems that are just used for development
  end

  begin
    require 'i18n'
    I18n.load_path =
      Dir["#{Pathname(__FILE__).dirname}/resume/cli/locales/*.yml"]
    I18n.available_locales = [:en, :ja]
  rescue LoadError
    puts 'This app is bilingual and needs the I18n gem.'
    puts 'Please run: gem install i18n'
    exit
  end
end
