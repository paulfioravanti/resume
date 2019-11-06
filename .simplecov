# Only run coverage when running spec suite outside of Guard
unless ENV["NO_COVERAGE"]
  if ENV["TRAVIS"]
    SimpleCov.formatter =
      SimpleCov::Formatter::MultiFormatter.new(
        [SimpleCov::Formatter::HTMLFormatter]
      )
    SimpleCov.start do
      add_filter "/spec/"
      SimpleCov.minimum_coverage 100
    end
  else
    SimpleCov.start do
      SimpleCov.minimum_coverage 100
      add_filter "/spec/"
    end
  end
end
