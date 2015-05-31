if ENV['TRAVIS']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

require 'rspec'
require 'resume/cli/colours'

RSpec.configure do |config|
  include Resume::CLI::Colours

  config.disable_monkey_patching!
  config.before(:suite) do
    begin
      require 'prawn'
      require 'prawn/table'
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
    end
  end
end
