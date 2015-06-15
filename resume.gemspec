require_relative 'lib/resume'

Gem::Specification.new do |gem|
  gem.name          = 'resume'
  gem.version       = Resume::VERSION
  gem.summary       = %q{Resume Generator}
  gem.description   = %q{Generates my resume using the Prawn PDF library}
  gem.license       = 'MIT'
  gem.authors       = ['Paul Fioravanti']
  gem.email         = 'paul.fioravanti@gmail.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'guard-rspec', '~> 4.5'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'prawn', '2.0.1'
  gem.add_development_dependency 'prawn-table', '0.2.1'
  gem.add_development_dependency 'kramdown', '~> 1.7'
  gem.add_development_dependency 'fuubar', '2.0.0'
  gem.add_development_dependency 'simplecov', '~> 0.10'
  gem.add_development_dependency 'reek', '2.2.1'
  gem.add_development_dependency 'codeclimate-test-reporter', '0.4.7'
end
