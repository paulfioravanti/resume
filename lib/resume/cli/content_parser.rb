require "json"
require "base64"
require_relative "file_fetcher"
require_relative "file_system"

module Resume
  module CLI
    module ContentParser
      ASSET_PATH = /dropbox/
      private_constant :ASSET_PATH
      # Regex taken from http://stackoverflow.com/q/8571501/567863
      BASE64_STRING_REGEX = %r{\A
        ([A-Za-z0-9+/]{4})*
        ([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)
      \z}x
      private_constant :BASE64_STRING_REGEX

      module_function

      def decode_content(string)
        # Force encoding to UTF-8 is needed for strings that had UTF-8
        # characters in them when they were originally encoded
        Base64.strict_decode64(string).force_encoding("utf-8")
      end

      def parse(resume)
        JSON.recurse_proc(resume, &decode_and_fetch_assets)
      end

      # Values that need parsing can be found in hash and array values
      # in the JSON, so specifically target those data types for
      # manipulation, and ignore any direct references given to the
      # keys or values of the JSON hash.
      def decode_and_fetch_assets
        proc do |object|
          case object
          when Hash
            parse_hash(object)
          when Array
            parse_array(object)
          else
            object
          end
        end
      end
      private_class_method :decode_and_fetch_assets

      def parse_hash(hash)
        hash.each do |key, value|
          if value =~ BASE64_STRING_REGEX
            value = decode_content(value)
          end
          if value =~ ASSET_PATH
            hash[key] = FileFetcher.fetch(value)
            next
          end
          munge_hash_value(hash, key, value)
        end
      end
      private_class_method :parse_hash

      def munge_hash_value(hash, key, value)
        if key == :align
          # Prawn specifically requires :align values to
          # be symbols otherwise it errors out
          hash[key] = value.to_sym
        elsif key == :styles && value.is_a?(Array)
          # Prawn specifically requires :styles values to
          # be symbols otherwise the styles do not take effect
          hash[key] = value.map!(&:to_sym)
        elsif key == :font && value.is_a?(Hash)
          # This is the hash that tells Prawn what the fonts to be used
          # are called and where they are located
          substitute_filenames_for_filepaths(value)
        else
          hash[key] = value
        end
      end
      private_class_method :munge_hash_value

      def substitute_filenames_for_filepaths(value)
        %i(normal bold).each do |property|
          if value.key?(property)
            value[property] = FileSystem.tmpfile_path(value[property])
          end
        end
      end
      private_class_method :substitute_filenames_for_filepaths

      def parse_array(array)
        array.each_with_index do |value, index|
          if value =~ BASE64_STRING_REGEX
            array[index] = decode_content(value)
          end
        end
      end
      private_class_method :parse_array
    end
  end
end
