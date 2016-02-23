module Resume
  VERSION = '1.2'
  REMOTE_REPO =
    'https://raw.githubusercontent.com/paulfioravanti/resume/master'
  REQUIRED_RUBY_VERSION = '2.3.0'

  def self.generate
    check_ruby_version
    require_relative 'resume/cli/application'
    CLI::Application.start
  end

  def self.check_ruby_version
    # Only needed for ruby pre-1.9.0 but it's safe for
    # later versions (evaluates to false).
    require 'rubygems'
    if Gem::Version.new(RUBY_VERSION.dup) <
      Gem::Version.new(REQUIRED_RUBY_VERSION)
      request_to_install_latest_ruby
    end
  rescue LoadError
    # NOTE: LoadError could occur if someone attempts to run
    # this with Ruby 1.8.7 and they don't have rubygems installed
    request_to_install_latest_ruby
  end

  def self.request_to_install_latest_ruby
    puts "Please install Ruby version 2.3.0 or higher "\
         "to generate resume"
    exit
  end
  private_class_method :request_to_install_latest_ruby
end
