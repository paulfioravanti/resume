require_relative 'resume/cli/application'

module Resume
  VERSION = '1.1'
  REMOTE_REPO = 'https://raw.githubusercontent.com/paulfioravanti/resume/master'
  # Specific 4-letter words to be excluded from Base64 decoding.
  # Needed because, for example:
  # > Base64.strict_decode64('bold')
  # => "n\x89]"
  RESERVED_WORDS = ['bold', 'left']

  def self.generate
    CLI::Application.start
  end
end
