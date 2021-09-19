require "rubygems"

begin
  require "bundler"
rescue LoadError => error
  warn(error.message)
  warn("Run `gem install bundler` to install Bundler.")
  exit(-1)
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => error
  warn(error.message)
  warn("Run `bundle install` to install missing gems.")
  exit(error.status_code)
end

require "rake"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

desc "Runs the tests"
task test: :spec
desc "Runs the tests by default"
task default: :spec

require "reek/rake/task"
Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

Rake.add_rakelib("lib/tasks")
