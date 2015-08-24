require 'json'
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
          FileFetcher.fetch(I18n.t(:resume_data_file)).read,
          symbolize_names: true
        )
      end
    end
  end
end
