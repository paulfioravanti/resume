require 'pathname'
require_relative 'resume/cli/application'

module Resume
  VERSION = '0.6'
  REMOTE_REPO =
    # "https://raw.githubusercontent.com/paulfioravanti/resume/master"
    "https://raw.githubusercontent.com/paulfioravanti/resume/ja-resume-refactor"

  def self.generate
    CLI::Application.start
  end
end
