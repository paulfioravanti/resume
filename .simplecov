# Only run coverage when running spec suite outside of Guard
unless ENV["NO_COVERAGE"]
  SimpleCov.start do
    SimpleCov.minimum_coverage 100
  end

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
    require "scrutinizer/ocular/formatter"
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      Scrutinizer::Ocular::UploadingFormatter
    ]
  end
end
