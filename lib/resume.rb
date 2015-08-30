require 'pathname'
require_relative 'resume/cli/application'

module Resume
  VERSION = '0.6'
  DATA_LOCATION = 'resources/'
  LOCALE_FILES =
    Dir["#{Pathname(__FILE__).dirname}/resume/locales/*.yml.erb"]

  def self.generate
    CLI::Application.start
  end
end
