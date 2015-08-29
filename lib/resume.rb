require_relative 'resume/cli/application'

module Resume
  VERSION = '0.6'
  DATA_LOCATION = 'resources/'

  def self.generate
    CLI::Application.start
  end
end
