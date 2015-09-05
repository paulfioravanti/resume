require 'pathname'
require_relative 'resume/cli/application'

module Resume
  VERSION = '0.6'

  def self.generate
    CLI::Application.start
  end
end
