module Resume
  VERSION = "1.3".freeze

  module_function

  def generate
    require_relative "resume/ruby_version_checker"
    RubyVersionChecker.check_ruby_version
    require_relative "resume/cli/application"
    CLI::Application.start
  end
end
