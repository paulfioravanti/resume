require_relative "lib/resume"

# rubocop:disable Metrics/BlockLength
# NOTE: Remove this disable when Code Climate Rubocop version updates
Gem::Specification.new do |spec|
  spec.name          = "resume"
  spec.version       = Resume::VERSION
  spec.summary       = "Resume Generator"
  spec.description   = "Generates my resume using the Prawn PDF library"
  spec.license       = "MIT"
  spec.authors       = ["Paul Fioravanti"]
  spec.email         = "paul.fioravanti@gmail.com"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "i18n", "~> 0.8"
  spec.add_dependency "prawn", "~> 2.2.0"
  spec.add_dependency "prawn-table", "~> 0.2.2"
  spec.add_dependency "rubyzip", "~> 1.2"

  spec.add_development_dependency "awesome_print", "~> 1.8"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "bundler-audit", "~> 0.5"
  spec.add_development_dependency "codacy-coverage", "~> 1.1"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
  spec.add_development_dependency "codecov", "~> 0.1"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "fuubar", "~> 2.2.0"
  spec.add_development_dependency "guard-reek", "~> 1.0"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "guard-rubocop", "~> 1.2"
  spec.add_development_dependency "guard-yard", "~> 2.2"
  spec.add_development_dependency "kramdown", "~> 1.8"
  spec.add_development_dependency "license_finder", "~> 4.0"
  spec.add_development_dependency "pry-byebug", "~> 3.1"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "reek", "~> 4.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rubocop", "~> 0.49"
  spec.add_development_dependency "rubocop-rspec", "~> 1.9"
  spec.add_development_dependency "rubygems-tasks", "~> 0.2"
  spec.add_development_dependency "scrutinizer-ocular", "~> 1.0"
  spec.add_development_dependency "simplecov", "~> 0.14"
  spec.add_development_dependency "yard", "~> 0.8"
end
# rubocop:enable Metrics/BlockLength
