if ENV['TRAVIS']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

require 'resume/colours'
require 'rspec'
require 'open-uri'

RSpec.configure do |config|
  include Resume::Colours

  config.disable_monkey_patching!
  config.before(:suite) do
    begin
      # TODO: Confirm whether Output class can be used here
      require 'prawn'
      require 'prawn/table'
      # Test access to the 1x1 pixel image needed for specs
      open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
    rescue LoadError
      puts red(
        'You need to have the prawn and prawn-table gems installed in '\
        'order to run the specs.'
      )
      puts yellow(
        'Either install them yourself or run the resume and it will '\
        'install them for you.'
      )
      exit
    rescue OpenURI::HTTPError
      puts red(
        'You need to have an internet connection in order to run the specs.'
      )
      puts yellow(
        'Please ensure that you have one before running them.'
      )
      exit
    end
  end
end
