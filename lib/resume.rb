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
  rescue LoadError
    puts 'This app is bilingual and needs the I18n gem.'
    puts 'Please run: gem install i18n'
    exit
  end
end
