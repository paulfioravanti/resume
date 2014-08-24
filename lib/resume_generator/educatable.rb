require 'utilities'

module ResumeGenerator
  # Methods are deliberately named obscurely to negate keyword indexing in
  # online code repositories, but they represent each entry in the
  # Education section
  module Educatable
    include Utilities

    def education_listing_for(entry)
      header_for(entry)
      logo_link_for(entry)
    end
  end
end