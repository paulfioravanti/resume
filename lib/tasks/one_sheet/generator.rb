require_relative '../../resume/cli/colours'
require_relative 'cli_files'

module OneSheet
  class Generator
    include Resume::CLI::Colours

    attr_accessor :content
    attr_reader :resume_path, :pdf_path, :pdf_entry_path,
                :spec_path, :cli_spec_path, :pdf_spec_path,
                :resume_files, :pdf_files_1, :pdf_files_2,
                :pdf_entry_files, :spec_files, :cli_spec_files, :pdf_spec_files

    def self.run
      new.run
    end

    private_class_method :new

    def initialize
      @content = ''
      @cli_path = 'lib/resume/cli/'
      @resume_path = 'lib/resume/'
      @pdf_path = 'lib/resume/pdf/'
      @pdf_entry_path = "#{@pdf_path}entry/"
      @spec_path = "spec/"
      @cli_spec_path = "#{@spec_path}#{@cli_path}"
      @pdf_spec_path = "#{@spec_path}#{@pdf_path}"
      @resume_files = [
        ['decoder', 3, -2]
      ]
      @pdf_files_1 = [
        ['font', 1, -3],
        ['name', 2, -3],
        ['headline', 2, -3],
        ['transparent_link', 2, -3],
        ['logo', 2, -3],
        ['social_media_logo_set', 5, -3]
      ]
      @pdf_entry_files = [
        ['heading', 2, -4],
        ['header', 3, -4],
        ['company_logo', 3, -4],
        ['content', 6, -3]
      ]
      @pdf_files_2 = [
        ['technical_skills', 4, -3],
        ['employment_history', 4, -3],
        ['education_history', 2, -3],
        ['manifest', 10, -3],
        ['options', 2, -3],
        ['document', 9, -1],
      ]
      @spec_files = [
        ['spec_helper', 8, -1]
      ]
      @cli_spec_files = [
        ['application_spec', 3, -1],
        ['argument_parser_spec', 3, -1],
        ['file_system_spec', 4, -1],
        ['gem_installer_spec', 4, -1]
      ]
      @pdf_spec_files = [
        ['document_spec', 3, -1, '']
      ]
    end

    def run
      instructions
      requires
      open_resume_module
      content << CLIFiles.read
      resume_files.each do |file, from_line, to_line|
        read_file(resume_path, file, from_line, to_line)
      end
      pdf_files_1.each do |file, from_line, to_line|
        read_file(pdf_path, file, from_line, to_line)
      end
      pdf_entry_files.each do |file, from_line, to_line|
        read_file(pdf_entry_path, file, from_line, to_line)
      end
      pdf_files_2.each do |file, from_line, to_line|
        read_file(pdf_path, file, from_line, to_line)
      end
      start_app
      spec_files.each do |file, from_line, to_line|
        read_file(spec_path, file, from_line, to_line)
      end
      cli_spec_files.each do |file, from_line, to_line|
        read_file(cli_spec_path, file, from_line, to_line)
      end
      pdf_spec_files.each do |file, from_line, to_line, line_break|
        read_file(pdf_spec_path, file, from_line, to_line, line_break)
      end
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

    def read_file(path, file, from_line, to_line, line_break = "\n")
      lines = File.readlines("#{path}#{file}.rb")
      content << lines[from_line..to_line].join << line_break
    end

    def start_app
      content << <<-START
  if __FILE__ == $0
    Resume::CLI::Application.start
  end

      START
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
