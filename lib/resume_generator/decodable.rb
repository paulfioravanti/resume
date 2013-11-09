require 'base64'

module ResumeGenerator
  module Decodable
    def d(string) # decode string
      Base64.strict_decode64(string)
    end
  end
end
