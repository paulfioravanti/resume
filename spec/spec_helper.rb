if ENV['TRAVIS']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
end

require 'rspec'
require 'open-uri'
require 'resume'
require 'resume/settings'
require 'resume/file_fetcher'
require 'resume/output'

module Resume
  RSpec.configure do |config|
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
    config.disable_monkey_patching!
    config.before(:suite) do
      begin
        Settings.configure
        require 'prawn'
        require 'prawn/table'
        # Grab the resume background image.  This serves two purposes:
        # 1. Grabs the biggest image and puts it in the tmp directory
        #    if it's not already there
        # 2. Tests out network connection
        # If the file is fetched locally, chances are high that the
        # resume has already been generated once and there won't be
        # a need to fetch the resources again.
        FileFetcher.fetch(
          'http://farm6.staticflickr.com/5453/8801916021_3ac1df6072_o_d.jpg'
        )
      rescue DependencyPrerequisiteError => e
        Output.messages(e.messages)
        exit
      rescue LoadError
        Output.messages({
          error: :you_need_prawn_to_run_the_specs,
          warning: :please_install_them_or_run_the_resume
        })
        exit
      rescue SocketError, OpenURI::HTTPError
        Output.messages({
          error: :you_need_an_internet_connection_to_run_the_specs,
          warning: :please_ensure_you_have_one
        })
        exit
      end
    end
  end
end
