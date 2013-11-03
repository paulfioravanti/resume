require 'simplecov'
require 'resume'

require 'rspec'
Dir[File.dirname(__FILE__) + '/support/*.rb'].each {|file| require file }

include Resume