require "json"
require_relative "../output"
require_relative "file_fetcher"

module Resume
  module CLI
    module ResumeDataFetcher
      module_function

      def fetch
        Output.plain(:gathering_resume_information)
        resume = FileFetcher.fetch("resources/resume.#{I18n.locale}.json")
        JSON.parse(resume.read, symbolize_names: true)
      end
    end
  end
end
