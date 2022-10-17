module Resume
  # Ensures that the version of Ruby being used is recent enough
  # to generate the resume.
  #
  # @author Paul Fioravanti
  module RubyVersionChecker
    # Required Ruby version for resume to work
    REQUIRED_RUBY_VERSION = "3.1.2".freeze
    private_constant :REQUIRED_RUBY_VERSION
    # Ruby version command
    RUBY_VERSION_COMMAND = "ruby -v".freeze
    private_constant :RUBY_VERSION_COMMAND
    # Ruby version output regex.
    # For example, this will extract `3.1.2` from a string like:
    # ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [arm64-darwin21]
    RUBY_VERSION_REGEX = /\Aruby ([\d.][^p]+)/
    private_constant :RUBY_VERSION_REGEX

    module_function

    # Checks the Ruby version being used to generate the resume.
    #
    # @return [nil]
    #   if rubygems is successfully required and the Ruby version is either
    #   installed or not installed.
    # @note On the one-sheet resume, this check will only work for
    #   >= Ruby 2.1  Earlier versions will throw a syntax error.
    def check_ruby_version
      # require "rubygems" only needed for ruby pre-1.9.0
      # but it's safe for later versions (evaluates to false).
      require "rubygems"
      request_to_install_latest_ruby if old_ruby_version?
    rescue LoadError
      # NOTE: LoadError could occur if someone attempts to run
      # this with Ruby 1.8.7 and they don't have rubygems installed
      request_to_install_latest_ruby
    end

    def old_ruby_version?
      Gem::Version.new(RUBY_VERSION.dup) <
        Gem::Version.new(REQUIRED_RUBY_VERSION)
    end
    private_class_method :old_ruby_version?

    def request_to_install_latest_ruby
      puts "Please install Ruby version #{REQUIRED_RUBY_VERSION} " \
           "or higher to generate resume."
      require "open3"
      puts "Your Ruby version is #{user_ruby_version}"
    rescue LoadError
      # NOTE: LoadError will likely occur if someone attempts to run
      # this with Ruby 1.8.7 and they don't have rubygems installed
      puts "Your Ruby version is likely far too old to generate the resume."
    ensure
      exit(1)
    end
    private_class_method :request_to_install_latest_ruby

    def user_ruby_version
      ruby_version =
        Open3.popen3(RUBY_VERSION_COMMAND) do |_stdin, stdout, _stderr, _wait|
          stdout.read
        end
      ruby_version.match(RUBY_VERSION_REGEX)[0]
    end
    private_class_method :user_ruby_version
  end
end
