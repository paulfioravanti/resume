require 'base64'

module ResumeGenerator
  module Decoder
    def self.included(base)
      # Allow #d to be available on the class level as well
      base.extend self
    end
    # This is just a helper method due to the sheer amount of decoding that
    # occurs throughout the code
    def d(string)
      return if string.nil?
      # Force encoding to UTF-8 is needed for strings that had UTF-8 characters
      # in them when they were originally encoded
      Base64.strict_decode64(string).force_encoding('utf-8')
    end
  end
end

