# Only run coverage when running spec suite outside of Guard
unless ENV["NO_COVERAGE"]
  if ENV["TRAVIS"]
    require "coveralls"
    require "codecov"
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::Codecov,
      Coveralls::SimpleCov::Formatter
    ]
  end

  if ENV["SCRUTINIZER"]
    require "scrutinizer/ocular"
    Scrutinizer::Ocular.watch!
  end

  SimpleCov.start do
    SimpleCov.minimum_coverage 100
  end
end
