require File.expand_path('../lib/resume_generator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'resume'
  gem.version       = ResumeGenerator::VERSION
  gem.summary       = %q{Resume Generator}
  gem.description   = %q{Generates my resume using the Prawn PDF library}
  gem.license       = 'MIT'
  gem.authors       = ['Paul Fioravanti']
  gem.email         = 'paul.fioravanti@gmail.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.7'
  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'prawn', '2.0.0'
  gem.add_development_dependency 'prawn-table', '0.2.1'
end
