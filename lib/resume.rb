require 'pathname'
require_relative 'resume/cli/application'

module Resume
  VERSION = '1.0'
  # REMOTE_REPO = "https://raw.githubusercontent.com/paulfioravanti/resume/master"
  REMOTE_REPO = "https://raw.githubusercontent.com/paulfioravanti/resume/ja-resume-refactor"

  def self.generate
    CLI::Application.start
  end
end
