require 'base64'

module ResumeGenerator
  module Decodable
    # This is just a helper method due to the sheer amount of decoding that
    # occurs throughout the code
    def d(string)
      Base64.strict_decode64(string)
    end
  end
end
