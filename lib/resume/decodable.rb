require 'base64'

module Resume
  module Decodable
    def d(string) # decode string
      Base64.strict_decode64(string)
    end
  end
end