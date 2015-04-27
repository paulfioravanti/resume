$LOAD_PATH << File.join(File.dirname(__FILE__), 'resume_generator')

require 'cli/colours'
require 'cli/cli'
require 'decoder'
require 'resume/image_link'
require 'resume/resume'
require 'version'

module ResumeGenerator
  PRAWN_VERSION = '2.0.0'
  PRAWN_TABLE_VERSION = '0.2.1'

  def self.locale
    @locale
  end

  def self.locale=(locale)
    @locale = locale
  end
end

