require 'simplecov'
require 'resume_generator'

require 'rspec'
Dir[File.dirname(__FILE__) + '/support/*.rb'].each {|file| require file }

include ResumeGenerator
