require 'base64'

module Resume
  module Decoder
    def self.included(base)
      # Allow #d to be available on the class level as well
      base.extend self
    end
    # This is just a helper method due to the sheer amount of decoding that
    # occurs throughout the code
    def decode(string)
      # Force encoding to UTF-8 is needed for strings that had UTF-8 characters
      # in them when they were originally encoded
      Base64.strict_decode64(string).force_encoding('utf-8') if string
    end
    alias_method :d, :decode
  end
end
