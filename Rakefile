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

task test: :spec
task default: :spec

require "reek/rake/task"
Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

Rake.add_rakelib("lib/tasks")

namespace :resume do
  task :generate_one_sheet do
    require_relative "lib/tasks/one_sheet/generator"
    OneSheet::Generator.run
  end

  desc "Delete assets downloaded into the local tmpdir"
  task :delete_assets do
    require_relative "lib/resume/output"
    Resume::Output.raw_warning("Deleting local assets in the tmpdir...")
    File.delete(*Dir.glob(File.join(Dir.tmpdir, "resume_*")))
    Resume::Output.raw_success("Successfully deleted local assets")
  end
end

desc "Generate the 'one-sheet' resume from the application"
task resume: "resume:generate_one_sheet"
