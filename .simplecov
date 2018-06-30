# Only run coverage when running spec suite outside of Guard
unless ENV["NO_COVERAGE"]
  if ENV["TRAVIS"]
    require "coveralls"
    require "codecov"
    require "codacy-coverage"
    SimpleCov.formatter =
      SimpleCov::Formatter::MultiFormatter.new(
        [
          SimpleCov::Formatter::HTMLFormatter,
          SimpleCov::Formatter::Codecov,
          Coveralls::SimpleCov::Formatter,
          Codacy::Formatter
        ]
      )
    SimpleCov.start do
      add_filter "/spec/"
      SimpleCov.minimum_coverage 100
    end
  elsif ENV["SCRUTINIZER"]
    require "scrutinizer/ocular"
    SimpleCov.minimum_coverage 100
    Scrutinizer::Ocular.watch!
  else
    SimpleCov.start do
      SimpleCov.minimum_coverage 100
      add_filter "/spec/"
    end
  end
end
