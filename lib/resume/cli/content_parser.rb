require 'json'
require 'base64'
require_relative '../output'
require_relative '../file_fetcher'
require_relative '../file_system'

module Resume
  module CLI
    class ContentParser
      def self.decode_content(string)
        # Force encoding to UTF-8 is needed for strings that had UTF-8
        # characters in them when they were originally encoded
        Base64.strict_decode64(string).force_encoding('utf-8')
      end

      def self.parse(resume)
        JSON.recurse_proc(resume, &decode_and_fetch_assets)
      end

      # Base64-encoded values can be found in hash and array values
      # in the JSON, so specifically target those data types for
      # manipulation, and ignore any direct references given to the
      # keys or values of the JSON hash.
      def self.decode_and_fetch_assets
        Proc.new do |object|
          case object
          when Hash
            object.each do |key, value|
              if key == :align
                # Prawn specifically requires :align values to
                # be symbols otherwise it errors out
                object[key] = value.to_sym
              elsif key == :font && value.is_a?(Hash)
                [:normal, :bold].each do |property|
                  if value.has_key?(property)
                    value[property] =
                      FileSystem.tmpfile_path(value[property])
                  end
                end
              else
                if encoded?(value)
                  value = ContentParser.decode_content(value)
                end
                if asset?(value)
                  value = FileFetcher.fetch(value)
                end
                object[key] = value
              end
            end
          when Array
            object.each_with_index do |value, index|
             if encoded?(value)
               object[index] = ContentParser.decode_content(value)
             end
            end
          else
            object
          end
        end
      end
      private_class_method :decode_and_fetch_assets

      def self.encoded?(string)
        # Checking whether a string is Base64-encoded is not an
        # exact science: 4 letter English words can be construed
        # as being encoded, so logic is needed to exclude words
        # known to not be encoded.
        base64_string?(string) && !RESERVED_WORDS.include?(string)
      end
      private_class_method :encoded?

      # Taken from http://stackoverflow.com/q/8571501/567863
      def self.base64_string?(string)
        string =~ %r{\A
          ([A-Za-z0-9+/]{4})*
          ([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)
        \z}x
      end
      private_class_method :base64_string?

      def self.asset?(string)
        string =~ %r{dropbox}
      end
      private_class_method :asset?
    end
  end
end
