if ENV['TRAVIS']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

require 'rspec'
RSpec.configure { |c| c.disable_monkey_patching! }
