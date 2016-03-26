# Only run Simplecov when not using Distributed Ruby
# To get coverage, stop Distributed Ruby server and run rspec
unless ENV['DRB']
  SimpleCov.start do
    add_filter '/spec/'
    SimpleCov.minimum_coverage 100
  end
end
