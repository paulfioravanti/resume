source 'http://rubygems.org'
ruby File.read('.ruby-version').strip.split('-').last

gemspec

group :development do
  gem 'kramdown'
  gem 'fuubar'
  gem 'simplecov'
  gem 'reek'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end
