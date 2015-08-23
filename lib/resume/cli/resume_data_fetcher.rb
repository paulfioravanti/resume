require 'open-uri'
require 'json'
require 'socket'
require_relative 'exceptions'
require_relative '../file_fetcher'

module Resume
  module CLI
    class ResumeDataFetcher

      def self.fetch
        new.fetch
      end

      private_class_method :new

      def fetch
        Output.plain(:gathering_resume_information)
        JSON.parse(
          FileFetcher.fetch(resume_data_file).read,
          symbolize_names: true
        )
      end

      private

      def resume_data_file
        "#{DATA_LOCATION}resume.#{I18n.locale}.json"
      end
    end
  end
end
