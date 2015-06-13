if ENV['TRAVIS']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

require 'resume/cli/colours'
require 'rspec'

RSpec.configure do |config|
  include Resume::CLI::Colours

  config.disable_monkey_patching!
  config.before(:suite) do
    begin
      require 'prawn'
      require 'prawn/table'
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
        'Please ensure that you have one before running the specs.'
      )
      exit
    end
  end
end
