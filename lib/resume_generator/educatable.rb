require 'utilities'

module ResumeGenerator
  module Educatable
    include Utilities

    def mit(entry)
      header_text_for(entry, 5)
      organisation_logo_for(entry, :mit)
    end

    def bib(entry)
      move_up 38
      header_text_for(entry, 0)
      move_up 30
      organisation_logo_for(entry, :bib, 0)
    end

    def ryu(entry)
      header_text_for(entry, 20)
      organisation_logo_for(entry, :ryu)
    end

    def tafe(entry)
      move_up 38
      header_text_for(entry, 0)
      move_up 23
      organisation_logo_for(entry, :tafe, 0)
    end
  end
end