require 'base64'

module Resume
  class Decoder
    RESERVED_WORDS = ['bold', 'left']

    def self.decode(string)
      return string unless encoded?(string)
      # Force encoding to UTF-8 is needed for strings that had UTF-8
      # characters in them when they were originally encoded
      Base64.strict_decode64(string).force_encoding('utf-8')
    end

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
  end
end
