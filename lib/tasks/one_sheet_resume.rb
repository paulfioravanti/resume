require_relative '../resume/cli/colours'

class OneSheetResume
  include Resume::CLI::Colours

  attr_accessor :content

  def self.generate
    new.generate
  end

  private_class_method :new

  def initialize
    @content = ''
  end

  def generate
    instructions
    requires
    open_resume_module
    cli_colours
    cli_messages
    cli_argument_parser
    cli_gem_installer
    cli_file_system
    cli_application
    decoder
    pdf_font
    pdf_name
    pdf_headline
    pdf_transparent_link
    pdf_logo
    pdf_social_media_logo_set
    pdf_entry_heading
    pdf_entry_header
    pdf_entry_company_logo
    pdf_entry_content
    pdf_technical_skills
    pdf_employment_history
    pdf_education_history
    pdf_manifest
    pdf_options
    pdf_document
    start_app
    spec_helper
    cli_application_spec
    cli_argument_parser_spec
    cli_file_system_spec
    cli_gem_installer_spec
    pdf_document_spec
    output_file
    run_specs
  end

  private

  def instructions
    content << <<-INSTRUCTIONS
# encoding: utf-8
################################################################################
### The modularised version of this resume lives online at
### https://github.com/paulfioravanti/resume
### in case you want to see a more readable, structured version of the files.
### This one-sheet version of the resume was generated via a Rake task.
###
### Instructions:
### 1. Make sure you run this with Ruby 2.2.2
###
### 2. Please ensure you have an internet connection as the script needs
###    Ruby gems for PDF generation, small images from Flickr, and resume data
###    from Github.  If that is not possible or you'd rather not let the script
###    make those connections, please contact me directly for the PDF file.
###
### 3. Run the script:
###
###    $ ruby resume.rb
###
### 4. If you have RSpec 3.2 or above installed, run the specs:
###
###    $ rspec resume.rb
###
################################################################################
    INSTRUCTIONS
  end

  def requires
    content << <<-REQUIRES
require 'base64'
require 'open-uri'
require 'json'
require 'optparse'
require 'socket'
require 'forwardable'

    REQUIRES
  end

  def open_resume_module
    content << <<-OPEN_MODULE
module Resume
  # These consts would only ever be defined when this file's specs
  # are run in the repo with the structured version of the resume: an edge case
  remove_const(:VERSION) if const_defined?(:VERSION)
  remove_const(:DATA_LOCATION) if const_defined?(:DATA_LOCATION)
  VERSION = '0.6'
  DATA_LOCATION =
    "https://raw.githubusercontent.com/paulfioravanti/resume/master/resources/"

    OPEN_MODULE
  end

  def cli_colours
    lines = File.readlines('lib/resume/cli/colours.rb')
    # Open CLI module
    content << lines[1..-3].join << "\n"
  end

  def cli_messages
    lines = File.readlines('lib/resume/cli/messages.rb')
    content << lines[4..-3].join << "\n"
  end

  def cli_argument_parser
    lines = File.readlines('lib/resume/cli/argument_parser.rb')
    content << lines[6..-3].join << "\n"
  end

  def cli_gem_installer
    lines = File.readlines('lib/resume/cli/gem_installer.rb')
    content << lines[2..-3].join << "\n"
  end

  def cli_file_system
    lines = File.readlines('lib/resume/cli/file_system.rb')
    content << lines[2..-3].join << "\n"
  end

  def cli_application
    lines = File.readlines('lib/resume/cli/application.rb')
    # Close CLI module
    content << lines[8..-2].join << "\n"
  end

  def decoder
    lines = File.readlines('lib/resume/decoder.rb')
    # Open/close Decoder module
    content << lines[3..-2].join << "\n"
  end

  def pdf_font
    lines = File.readlines('lib/resume/pdf/font.rb')
    # Open PDF module
    content << lines[1..-3].join << "\n"
  end

  def pdf_name
    lines = File.readlines('lib/resume/pdf/name.rb')
    content << lines[2..-3].join << "\n"
  end

  def pdf_headline
    lines = File.readlines('lib/resume/pdf/headline.rb')
    content << lines[2..-3].join << "\n"
  end

  def pdf_transparent_link
    lines = File.readlines('lib/resume/pdf/transparent_link.rb')
    content << lines[2..-3].join << "\n"
  end

  def pdf_logo
    lines = File.readlines('lib/resume/pdf/logo.rb')
    content << lines[2..-3].join << "\n"
  end

  def pdf_social_media_logo_set
    lines = File.readlines('lib/resume/pdf/social_media_logo_set.rb')
    content << lines[5..-3].join << "\n"
  end

  def pdf_entry_heading
    lines = File.readlines('lib/resume/pdf/entry/heading.rb')
    # Open Entry module
    content << lines[2..-4].join << "\n"
  end

  def pdf_entry_header
    lines = File.readlines('lib/resume/pdf/entry/header.rb')
    content << lines[3..-4].join << "\n"
  end

  def pdf_entry_company_logo
    lines = File.readlines('lib/resume/pdf/entry/company_logo.rb')
    content << lines[3..-4].join << "\n"
  end

  def pdf_entry_content
    lines = File.readlines('lib/resume/pdf/entry/content.rb')
    # Close Entry module
    content << lines[6..-3].join << "\n"
  end

  def pdf_technical_skills
    lines = File.readlines('lib/resume/pdf/technical_skills.rb')
    content << lines[4..-3].join << "\n"
  end

  def pdf_employment_history
    lines = File.readlines('lib/resume/pdf/employment_history.rb')
    content << lines[4..-3].join << "\n"
  end

  def pdf_education_history
    lines = File.readlines('lib/resume/pdf/education_history.rb')
    content << lines[2..-3].join << "\n"
  end

  def pdf_manifest
    lines = File.readlines('lib/resume/pdf/manifest.rb')
    content << lines[10..-3].join << "\n"
  end

  def pdf_options
    lines = File.readlines('lib/resume/pdf/options.rb')
    # Close PDF Module
    content << lines[2..-3].join << "\n"
  end

  def pdf_document
    lines = File.readlines('lib/resume/pdf/document.rb')
    content << lines[9..-1].join << "\n"
  end

  def start_app
    content << <<-START
if __FILE__ == $0
  Resume::CLI::Application.start
end

    START
  end

  def spec_helper
    lines = File.readlines('spec/spec_helper.rb')
    content << lines[8..-1].join << "\n"
  end

  def cli_application_spec
    lines = File.readlines('spec/lib/resume/cli/application_spec.rb')
    content << lines[3..-1].join << "\n"
  end

  def cli_argument_parser_spec
    lines = File.readlines('spec/lib/resume/cli/argument_parser_spec.rb')
    content << lines[3..-1].join << "\n"
  end

  def cli_file_system_spec
    lines = File.readlines('spec/lib/resume/cli/file_system_spec.rb')
    content << lines[4..-1].join << "\n"
  end

  def cli_gem_installer_spec
    lines = File.readlines('spec/lib/resume/cli/file_system_spec.rb')
    content << lines[4..-1].join << "\n"
  end

  def pdf_document_spec
    lines = File.readlines('spec/lib/resume/pdf/document_spec.rb')
    content << lines[3..-1].join
  end

  def output_file
    File.open('resume.rb', 'w') do |file|
      file.write(content)
    end
    puts green('Successfully generated one-sheet resume')
  end

  def run_specs
    puts yellow('Running specs...')
    system('rspec', 'resume.rb')
  end
end
