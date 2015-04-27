require 'resume_generator/cli'
require 'resume_generator/decoder'
require 'resume_generator/resume'
require 'resume_generator/version'

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

