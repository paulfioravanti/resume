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
        result = JSON.parse(resume.read, symbolize_names: true)
        JSON.recurse_proc(result, &decode_encoded_strings)
      end

      private

      # Base64-encoded values can be found in hash and array values
      # in the JSON, so specifically target those data types for
      # manipulation, and ignore any direct references given to the
      # keys or values of the JSON hash.
      def decode_encoded_strings
        Proc.new do |object|
          case object
          when Hash
            object.each do |key, value|
              object[key] = Decoder.decode(value)
            end
          when Array
            object.each_with_index do |value, index|
              object[index] = Decoder.decode(value)
            end
          else
            object
          end
        end
      end
    end
  end
end
