require 'json'
require 'base64'
require_relative 'output'
require_relative 'file_fetcher'

module Resume
  class Parser
    def self.parse(resume)
      new(resume).parse
    end

    def self.decode_content(string)
      # Force encoding to UTF-8 is needed for strings that had UTF-8
      # characters in them when they were originally encoded
      Base64.strict_decode64(string).force_encoding('utf-8')
    end

    private_class_method :new

    def initialize(resume)
      @resume = resume
    end

    def parse
      parse_resume
      resume
    end

    private

    attr_accessor :resume

    def parse_resume
      self.resume = JSON.recurse_proc(resume, &decode_and_fetch_assets)
    end

    # Base64-encoded values can be found in hash and array values
    # in the JSON, so specifically target those data types for
    # manipulation, and ignore any direct references given to the
    # keys or values of the JSON hash.
    def decode_and_fetch_assets
      Proc.new do |object|
        case object
        when Hash
          object.each do |key, value|
            if key == :align
              # Prawn specifically requires :align values to
              # be symbols otherwise it errors out
              object[key] = value.to_sym
            else
              if encoded?(value)
                value = Parser.decode_content(value)
              end
              if asset?(value)
                next if key == :location
                value = FileFetcher.fetch(value)
              end
              object[key] = value
            end
          end
        when Array
          object.each_with_index do |value, index|
           if encoded?(value)
             object[index] = Parser.decode_content(value)
           end
          end
        else
          object
        end
      end
    end


    def encoded?(string)
      # Checking whether a string is Base64-encoded is not an
      # exact science: 4 letter English words can be construed
      # as being encoded, so logic is needed to exclude words
      # known to not be encoded.
      base64_string?(string) && !RESERVED_WORDS.include?(string)
    end

    # Taken from http://stackoverflow.com/q/8571501/567863
    def base64_string?(string)
      string =~ %r{\A
        ([A-Za-z0-9+/]{4})*
        ([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)
      \z}x
    end

    def asset?(string)
      string =~ %r{dropbox}
    end
  end
end
