require 'simplecov'
require 'resume/ruby_version_checker'
Resume::RubyVersionChecker.check_ruby_version

if ENV['TRAVIS']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rspec'
require 'open-uri'
require 'resume'
require 'resume/cli/settings'
require 'resume/cli/content_parser'
require 'resume/cli/file_fetcher'
require 'resume/output'

module Resume
  RSpec.configure do |config|
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
    config.disable_monkey_patching!
    config.before(:suite) do
      begin
        CLI::Settings.configure
        require 'prawn'
        require 'prawn/table'
        # Grab the resume background image.  This serves two purposes:
        # 1. Grabs the biggest image and puts it in the tmp directory
        #    if it's not already there
        # 2. Tests out network connection
        # If the file is fetched locally, chances are high that the
        # resume has already been generated once and there won't be
        # a need to fetch the resources again.
        CLI::FileFetcher.fetch(
          CLI::ContentParser.decode_content(
            "aHR0cHM6Ly9kbC5kcm9wYm94dXNlcmNvbnRlbnQuY29tL3UvNjg3"\
            "ODA1Mi9yZXN1bWVfYXNzZXRzL2JhY2tncm91bmQuanBnP2RsPTE="
          )
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
