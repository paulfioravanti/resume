require 'json'
require_relative '../file_fetcher'
require_relative '../output'

module Resume
  module CLI
    class ResumeDataFetcher < FileFetcher
      def self.fetch
        super("resources/resume.#{I18n.locale}.json")
      end

      def fetch
        Output.plain(:gathering_resume_information)
        resume = super
        JSON.parse(
          resume.read,
          symbolize_names: true
        )
      end
    end
  end
end
