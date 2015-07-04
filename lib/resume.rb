module Resume
  VERSION = '0.6'
  DATA_LOCATION = 'resources/'

  begin
    require 'pry-byebug'
  rescue LoadError
    # Ignore requiring gems that are just used for development
  end
end

