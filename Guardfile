# rubocop:disable Metrics/BlockLength
group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: "NO_COVERAGE=true bin/rspec" do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # Feel free to open issues for suggestions and improvements

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  end

  guard :rubocop,
        all_on_start: false,
        cli: ["--display-cop-names", "--format", "fuubar"] do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end

  guard :reek, all_on_start: false do
    # NOTE: Irresponsible Module issues (no top level documentation) occur on
    # generated resume.rb file that I don't care about, and I couldn't seem
    # to be able to filter it out of this guard scope, so just remove the file
    # as by this point it's already been tested.
    callback(:start_begin) { system("rm", "resume.rb") }
    watch(/.+\.rb$/)
    watch(".reek")
  end

  guard :yard, cli: "--reload" do
    watch(%r{app/.+\.rb})
    watch(%r{lib/.+\.rb})
    watch(%r{ext/.+\.c})
  end
end
# rubocop:enable Metrics/BlockLength
