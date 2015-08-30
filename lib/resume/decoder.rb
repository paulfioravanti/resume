require 'base64'

module Resume
  class Decoder
    def self.decode(string)
      # Force encoding to UTF-8 is needed for strings that had UTF-8
      # characters in them when they were originally encoded
      Base64.strict_decode64(string).force_encoding('utf-8')
    end

    singleton_class.send(:alias_method, :d, :decode)
  end
end
