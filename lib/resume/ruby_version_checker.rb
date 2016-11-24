module Resume
  module RubyVersionChecker
    REQUIRED_RUBY_VERSION = "2.3.3"
    private_constant :REQUIRED_RUBY_VERSION

    module_function

    # NOTE: On the one-sheet resume, this check will only work for
    # >= Ruby 2.1  Earlier versions will throw a syntax error.
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
      puts "Please install Ruby version 2.3.1 or higher to generate resume."
      require "open3"
      puts "Your Ruby version is #{user_ruby_version}"
      exit
    rescue LoadError
      # NOTE: LoadError will likely occur if someone attempts to run
      # this with Ruby 1.8.7 and they don't have rubygems installed
      exit
    end
    private_class_method :request_to_install_latest_ruby

    def user_ruby_version
      ruby_version =
        Open3.popen3("ruby -v") do |_stdin, stdout, _stderr, _wait_thr|
          stdout.read
        end
      ruby_version.match(/\Aruby ([\d\.][^p]+)/)[0]
    end
    private_class_method :user_ruby_version
  end
end
