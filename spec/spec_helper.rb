if ENV['TRAVIS']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

require 'rspec'
require 'open-uri'
require 'resume'
require 'resume/settings'
require 'resume/output'

# Setting configuration needs to be done at the top level in this case
# hence it's not done within the code in the Resume namespace below.

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.before(:suite) do
    begin
      Resume::Settings.configure
      require 'prawn'
      require 'prawn/table'
      # Test access to the 1x1 pixel image needed for specs
      StringIO.open(
        'http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg'
      )
    rescue Resume::DependencyPrerequisiteError => e
      Resume::Output.messages(e.messages)
      exit
    rescue LoadError
      Resume::Output.messages({
        error: :you_need_prawn_to_run_the_specs,
        warning: :please_install_them_or_run_the_resume
      })
      exit
    rescue SocketError, OpenURI::HTTPError
      Resume::Output.messages({
        error: :you_need_an_internet_connection_to_run_the_specs,
        warning: :please_ensure_you_have_one
      })
      exit
    end
  end
end
