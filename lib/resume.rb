# Top level module for resume CLI utility and PDF generation
#
# @author Paul Fioravanti
module Resume
  VERSION = "1.3".freeze

  module_function

  # Entry point for generating the PDF resume.
  #
  # Ensures that correct version of Ruby is being used before
  # attempting to generate it.
  #
  # @author Paul Fioravanti
  # @return [nil]
  def generate
    require_relative "resume/ruby_version_checker"
    RubyVersionChecker.check_ruby_version
    require_relative "resume/cli/application"
    CLI::Application.start
  end
end
