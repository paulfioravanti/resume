require "json"
require_relative "../output"
require_relative "file_fetcher"

module Resume
  module CLI
    # Module concerned with fetching and parsing a resume data JSON file.
    #
    # @author Paul Fioravanti
    module ResumeDataFetcher
      # Location of resume JSON data
      RESUME_LOCATION = ->(locale) { "resources/resume.#{locale}.json" }
      private_constant :RESUME_LOCATION

      module_function

      # Fetches the resume data JSON file for the current locale
      # and parses it into a Ruby hash.
      #
      # @return [Hash] The resume data
      def fetch
        Output.plain(:gathering_resume_information)
        resume = FileFetcher.fetch(RESUME_LOCATION.call(I18n.locale))
        JSON.parse(resume.read, symbolize_names: true)
      end
    end
  end
end
