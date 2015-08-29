require 'json'
require_relative '../file_fetcher'
require_relative '../output'

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
          FileFetcher.fetch(filename).read,
          symbolize_names: true
        )
      end

      private

      def filename
        I18n.t(:resume_data_filename, selected_locale: I18n.locale)
      end
    end
  end
end
