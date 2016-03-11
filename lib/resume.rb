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

  # NOTE: On the one-sheet resume, this check will only work for
  # >= Ruby 2.1  Earlier versions will throw a syntax error.
  def self.check_ruby_version
    # require 'rubygems' only needed for ruby pre-1.9.0
    # but it's safe for later versions (evaluates to false).
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
    puts "Please install Ruby version 2.3.0 or higher to generate resume."
    require 'open3'
    puts "Your Ruby version is #{ruby_version}"
    exit
  rescue LoadError
    # NOTE: LoadError will likely occur if someone attempts to run
    # this with Ruby 1.8.7 and they don't have rubygems installed
    exit
  end
  private_class_method :request_to_install_latest_ruby

  def self.ruby_version
    ruby_version =
      Open3.popen3('ruby -v') do |stdin, stdout, stderr, wait_thr|
        stdout.read
      end
    ruby_version.match(/\Aruby ([\d\.][^p]+)/)[0]
  end
  private_class_method :ruby_version
end
