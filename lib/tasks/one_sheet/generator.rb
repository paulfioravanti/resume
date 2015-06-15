require_relative '../../resume/cli/colours'
require_relative 'readable'
require_relative 'files'
require_relative 'pdf_files'
require 'yaml'

module OneSheet
  FILES = YAML.load_file(File.join(__dir__, 'files.yml'))

  class Generator
    include Resume::CLI::Colours, Readable

    attr_accessor :content

    def self.run
      new.run
    end

    private_class_method :new

    def initialize
      @content = ''
    end

    def run
      instructions
      requires
      open_resume_module
      content << Files.read(:cli_files)
      content << Files.read(:resume_files)
      read_files(PDFFiles)
      start_app
      content << Files.read(:spec_files)
      content << Files.read(:cli_spec_files)
      content << Files.read(:pdf_spec_files)
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

    def start_app
      content << <<-START_APP
if __FILE__ == $0
  Resume::CLI::Application.start
end

      START_APP
    end

    def read_files(files)
      content << files.read
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
end
