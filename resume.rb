# encoding: utf-8
require 'base64'
require 'open-uri'
require 'json'

################################################################################
### This resume lives online at https://github.com/paulfioravanti/resume
### in case you want to see a more readable, structured version of the files.
###
### Instructions:
### 1. Make sure you run this with Ruby 1.9.2 or greater (1.8.7 will not work)
### 2. Please let the script install the Prawn gem for PDF generation if you
###    don't have it already.  Otherwise, contact me directly for the PDF file.
### 3. The script will pull down some small images from Flickr, so please ensure
###    you have an internet connection.
### 4. Run the script:
###
###    $ ruby resume.rb
###
### 5. If you have RSpec installed, run the specs:
###
###    $ rspec resume.rb
###
################################################################################
module ResumeGenerator
  # This const would only ever be defined when this file's specs
  # are run in the repo with the structured version.
  VERSION = '0.0.1' unless const_defined?(:VERSION)
  DOCUMENT_NAME = 'Resume'

  module Colourable
    private

    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def red(text)
      colorize(text, 31)
    end

    def yellow(text)
      colorize(text, 33)
    end

    def green(text)
      colorize(text, 32)
    end

    def cyan(text)
      colorize(text, 36)
    end
  end

  class CLI
    include Colourable

    def self.report(string)
      puts string
    end

    def start
      check_ability_to_generate_resume
      generate_resume
      clean_up
    end

    private

    def check_ability_to_generate_resume
      return if required_gem_available?('prawn', '1.0.0')
      print yellow "May I please install version 1.0.0 of the 'Prawn'\n"\
                   "Ruby gem to help me generate a PDF (Y/N)? "
      if permission_granted?
        install_gem
      else
        puts red "Sorry, I won't be able to generate a PDF without this\n"\
                 "specific version of the Prawn gem.\n"\
                 "Please ask me directly for a PDF copy of my resume."
        exit
      end
    end

    def generate_resume
      gem 'prawn', '1.0.0'
      require 'prawn'
      Resume.generate
    end

    def clean_up
      puts green 'Resume generated successfully.'
      print yellow 'Would you like me to open the resume for you (Y/N)? '
      open_document if permission_granted?
      puts cyan "Thanks for looking at my resume. "\
                "I hope to hear from you soon!"
    end

    def open_document
      case RUBY_PLATFORM
      when %r(darwin)
        system("open #{DOCUMENT_NAME}.pdf")
      when %r(linux)
        system("xdg-open #{DOCUMENT_NAME}.pdf")
      when %r(windows)
        system("cmd /c \"start #{DOCUMENT_NAME}.pdf\"")
      else
        puts yellow "Sorry, I can't figure out how to open the resume on\n"\
                    "this computer. Please open it yourself."
      end
    end

    def required_gem_available?(name, version)
      Gem::Specification.find_by_name(name).version >= Gem::Version.new(version)
    rescue Gem::LoadError # gem not installed
      false
    end

    def permission_granted?
      gets.chomp.match(%r{\A(y|yes)\z}i)
    end

    def install_gem
      puts green 'Thank you kindly :-)'
      puts 'Installing Prawn gem version 1.0.0...'
      begin
        system('gem install prawn -v 1.0.0')
        puts green 'Prawn gem successfully installed.'
        Gem.clear_paths # Reset the dir and path values so Prawn can be required
      rescue
        puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
                 "Either try again or ask me directly for a PDF copy of "\
                 "my resume."
        exit
      end
    end
  end

  module Decodable
    def d(string) # decode string
      Base64.strict_decode64(string)
    end
  end

  class Resource
    extend Decodable

    attr_reader :image, :link, :width, :height, :fit, :align, :move_up, :bars,
                :size, :origin, :at

    def self.for(hash)
      hash[:image] = open(hash[:image])
      hash[:link] = d(hash[:link])
      hash[:align] = hash[:align].to_sym
      new(hash)
    end

    private

    def initialize(options)
      options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end

  module Utilities
    def header_text_for(entry, y_start = 15)
      move_down y_start
      return formatted_text_boxes_for(entry) if entry[:at]
      formatted_text_fields_for(entry)
    end

    def formatted_text_fields_for(entry)
      position(entry)
      organisation(entry)
      period_and_location(entry)
    end

    def formatted_text_boxes_for(entry)
      position_at(entry)
      organisation_at(entry)
      period_and_location_at(entry)
    end

    def transparent_link(resource)
      transparent(0) do
        formatted_text(
          [
            {
              text: '|' * resource.bars,
              size: resource.size,
              link: resource.link
            }
          ], align: resource.align
        )
      end
    end

    def heading(string)
      move_down 10
      formatted_text(
        [
          {
            text: string,
            styles: [:bold],
            color: '666666'
          }
        ]
      )
    end

    def position(entry)
      formatted_text(
        formatted_position(d(entry[:position]))
      )
    end

    def position_at(entry)
      formatted_text_box(
        formatted_position(d(entry[:position])),
        at: [entry[:at], cursor]
      )
      move_down 14
    end

    def formatted_position(string)
      [
        {
          text: string,
          styles: [:bold]
        }
      ]
    end

    def organisation(entry)
      formatted_text(
        formatted_organisation(d(entry[:organisation]))
      )
    end

    def organisation_at(entry)
      formatted_text_box(
        formatted_organisation(d(entry[:organisation])),
        at: [entry[:at], cursor]
      )
      move_down 13
    end

    def formatted_organisation(string)
      [
        {
          text: string,
          styles: [:bold],
          size: 11
        }
      ]
    end

    def period_and_location(entry)
      formatted_text(
        [
          {
            text: d(entry[:period])
          },
          {
            text: d(entry[:location][:name]),
            link: d(entry[:location][:link])
          }
        ],
        color: '666666',
        size: 10
      )
    end

    def period_and_location_at(entry)
      formatted_text_box(
        [
          {
            text: d(entry[:period]), color: '666666', size: 10
          },
          {
            text: d(entry[:location][:name]),
            link: d(entry[:location][:link]),
            color: '666666', size: 10
          }
        ],
        at: [entry[:at], cursor]
      )
    end
  end

  module Sociable
    include Utilities

    def resources_for(social_media)
      social_media[:resources].values.map do |social_medium|
        social_medium.merge!(social_media[:properties])
        Resource.for(social_medium)
      end
    end

    def social_media_icon_for(resource, x_position)
      bounding_box([x_position, cursor], width: resource.width) do
        image(
          resource.image,
          fit: resource.fit,
          align: resource.align
        )
        move_up 35
        transparent_link(resource)
      end
    end

    def organisation_logo_for(entry, logo, start_point = 40)
      organisation_logo = entry[:logos][logo]
      resource = logo_resource(entry, organisation_logo)
      move_up start_point
      bounding_box([resource.origin, cursor],
                   width: resource.width,
                   height: resource.height) do
        image resource.image, fit: resource.fit, align: resource.align
        move_up resource.move_up
        transparent_link(resource)
      end
    end

    def logo_resource(entry, logo)
      logo.merge!(at: entry[:at])
      Resource.for(logo)
    end
  end

  module Employable
    include Utilities

    def rc(entry)
      header_text_for(entry, 10)
      organisation_logo_for(entry, :rc)
      content_for(entry)
    end

    def fl(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :ruby)
      organisation_logo_for(entry, :rails, 33)
      content_for(entry, 15)
    end

    def gw(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :gw)
      content_for(entry)
    end

    def rnt(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :rnt)
      content_for(entry)
    end

    def sra(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :sra)
      content_for(entry)
    end

    def jet(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :jet)
      content_for(entry)
    end

    def satc(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :satc)
      content_for(entry)
    end

    def content_for(entry, start_point = 10)
      move_down start_point
      summary(entry[:summary])
      profile(entry[:profile])
    end

    def summary(string)
      text d(string)
    end

    def profile(items)
      return unless items
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [] })
    end
  end

  module Educatable
    include Utilities

    def mit(entry)
      header_text_for(entry)
      organisation_logo_for(entry, :mit)
    end

    def bib(entry)
      move_up 38
      header_text_for(entry, 0)
      move_up 30
      organisation_logo_for(entry, :bib, 0)
    end

    def ryu(entry)
      header_text_for(entry, 20)
      organisation_logo_for(entry, :ryu)
    end

    def tafe(entry)
      move_up 38
      header_text_for(entry, 0)
      move_up 23
      organisation_logo_for(entry, :tafe, 0)
    end
  end

  module ResumeHelper
    include Decodable, Sociable, Employable, Educatable

    RESUME =
      JSON.parse(
        open(
          "https://raw.github.com/paulfioravanti/"\
          "resume/master/resources/resume.json").read,
        symbolize_names: true
      )[:resume]

    def self.included(base)
      Resume.extend(ClassMethods)
    end

    module ClassMethods
      def background_image
        open(RESUME[:background_image])
      end
    end

    private

    def name
      font('Times-Roman', size: 20) { text d(RESUME[:name]) }
    end

    def headline
      headline = RESUME[:headline]
      formatted_text(
        [
          {
            text: d(headline[:ruby]), color: '85200C'
          },
          {
            text: d(headline[:other])
          }
        ],
        size: 14
      )
    end

    def social_media_icons
      social_media = RESUME[:social_media]
      move_down 5
      resources = resources_for(social_media)
      x_position = 0
      social_media_icon_for(resources.first, x_position)
      x_position += 45
      resources[1..-1].each do |resource|
        move_up 46.25
        social_media_icon_for(resource, x_position)
        x_position += 45
      end
      stroke_horizontal_rule { color '666666' }
    end

    def employment_history
      heading d('RW1wbG95bWVudCBIaXN0b3J5')
      entries = RESUME[:entries]
      rc(entries[:rc])
      fl(entries[:fl])
      gw(entries[:gw])
      rnt(entries[:rnt])
      sra(entries[:sra])
      jet(entries[:jet])
      satc(entries[:satc])
      move_down 10
      stroke_horizontal_rule { color '666666' }
    end

    def education_history
      heading d('RWR1Y2F0aW9u')
      entries = RESUME[:entries]
      mit(entries[:mit])
      bib(entries[:bib])
      ryu(entries[:ryu])
      tafe(entries[:tafe])
    end
  end

  class Resume
    def self.generate
      Prawn::Document.class_eval do
        include ResumeHelper
      end
      Prawn::Document.generate(
        "#{DOCUMENT_NAME}.pdf",
        margin_top: 0.75,
        margin_bottom: 0.75,
        margin_left: 1,
        margin_right: 1,
        background: background_image,
        repeat: true) do

        CLI.report "Generating PDF. "\
                   "This shouldn't take longer than a few seconds..."

        name
        headline

        CLI.report 'Creating social media links section...'
        social_media_icons

        CLI.report 'Creating employment history section...'
        employment_history

        CLI.report('Creating education history section...')
        education_history
      end
    end
  end
end

if __FILE__ == $0
  ResumeGenerator::CLI.new.start
end

module ResumeGenerator
  require 'rspec'

  describe CLI do
    include Colourable

    let(:cli) { CLI.new }
    # stub out the innards of permission_granted? (i.e. calls chained to #gets)
    # so it doesn't interfere with spec operation
    let(:user_input) { double('user_input', chomp: self, match: true) }

    before do
      allow(cli).to receive(:gets).and_return(user_input)
      allow(cli).to receive(:system) # stub out `gem install ...`
    end

    describe '.report' do
      let(:reporting_to_cli) { -> { CLI.report('hello') } }

      it 'outputs the passed in message to stdout' do
        expect(reporting_to_cli).to output("hello\n").to_stdout
      end
    end

    describe '#start' do
      it 'runs the script' do
        expect(cli).to receive(:check_ability_to_generate_resume)
        expect(cli).to receive(:generate_resume)
        expect(cli).to receive(:clean_up)
        cli.start
      end
    end

    describe 'PDF generator gem installation' do
      let(:prawn_gem) { double('prawn_gem') }

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn').and_return(prawn_gem)
        allow(Gem::Version).to receive(:new).and_return(1)
      end

      context 'user has the expected gem installed' do
        before do
          allow(prawn_gem).to receive(:version).and_return(1)
        end

        specify 'user is not asked to install the gem' do
          expect(cli).to_not receive(:permission_granted?)
          cli.send(:check_ability_to_generate_resume)
        end
      end

      context 'user has the expected gem installed, but an older version' do
        let(:checking_ability_to_generate_resume) do
          -> { cli.send(:check_ability_to_generate_resume) }
        end
        let(:message) do
          Regexp.escape(
            yellow "May I please install version 1.0.0 of the 'Prawn'\n"\
                   "Ruby gem to help me generate a PDF (Y/N)? "
          )
        end

        before do
          allow(prawn_gem).to receive(:version).and_return(0)
        end

        specify 'user is asked to install the gem' do
          expect(checking_ability_to_generate_resume).to \
            output(/#{message}/).to_stdout
        end
      end

      context 'user does not have the gem installed' do
        let(:checking_ability_to_generate_resume) do
          -> { cli.send(:check_ability_to_generate_resume) }
        end
        let(:message) do
          Regexp.escape(
            yellow "May I please install version 1.0.0 of the 'Prawn'\n"\
                   "Ruby gem to help me generate a PDF (Y/N)? "
          )
        end

        before do
          allow(Gem::Specification).to \
            receive(:find_by_name).and_raise(Gem::LoadError)
        end

        specify 'user is asked to install the gem' do
          expect(checking_ability_to_generate_resume).to \
            output(/#{message}/).to_stdout
        end

        context 'user agrees to install the gem' do
          let(:checking_ability_to_generate_resume) do
            -> { cli.send(:check_ability_to_generate_resume) }
          end
          let(:message) do
            Regexp.escape(
              green("Thank you kindly :-)") << "\n" <<
              "Installing Prawn gem version 1.0.0...\n" <<
              green("Prawn gem successfully installed.") << "\n"
            )
          end

          before do
            allow(cli).to receive(:permission_granted?).and_return(true)
          end

          it 'executes installation' do
            expect(checking_ability_to_generate_resume).to \
              output(/#{message}/).to_stdout
          end

          context 'gem is unable to be installed' do
            let(:checking_ability_to_generate_resume) do
              -> { cli.send(:check_ability_to_generate_resume) }
            end
            let(:message) do
              Regexp.escape(
                green("Thank you kindly :-)") << "\n" <<
                "Installing Prawn gem version 1.0.0...\n" <<
                red(
                  "Sorry, for some reason I wasn't able to install prawn.\n"\
                  "Either try again or ask me directly for a PDF copy of "\
                  "my resume."
                ) << "\n"
              )
            end

            before { allow(cli).to receive(:system).and_raise }

            it 'prints an error message and exits' do
              expect(cli).to receive(:exit)
              expect(checking_ability_to_generate_resume).to \
                output(/#{message}/).to_stdout
            end
          end
        end

        context 'when user does not agree to install the gem' do
          let(:checking_ability_to_generate_resume) do
            -> { cli.send(:check_ability_to_generate_resume) }
          end
          let(:message) do
            Regexp.escape(
              red(
                "Sorry, I won't be able to generate a PDF without this\n"\
                "specific version of the Prawn gem.\n"\
                "Please ask me directly for a PDF copy of my resume."
              ) << "\n"
            )
          end
          before do
            allow(cli).to receive(:permission_granted?).and_return(false)
          end

          it 'prints an error message and exits' do
            expect(cli).to receive(:exit)
            expect(checking_ability_to_generate_resume).to \
              output(/#{message}/).to_stdout
          end
        end
      end
    end

    describe 'generating the PDF' do
      before { allow(cli).to receive(:require).with('prawn') }

      it 'tells the PDF to generate itself' do
        expect(Resume).to receive(:generate)
        cli.send(:generate_resume)
      end
    end

    describe 'post-PDF generation' do
      it 'shows a success message and asks to open the resume' do
        # expect puts twice as it includes the printed message you get
        # regardless of whether you allow the script to open resume or not
        expect(cli).to receive(:puts).twice
        expect(cli).to receive(:print)
        cli.send(:clean_up)
      end

      context 'user allows the script to open the PDF' do
        let(:document_name) { ResumeGenerator::DOCUMENT_NAME }

        before { allow(cli).to receive(:permission_granted?).and_return(true) }

        it 'attempts to open the document' do
          expect(cli).to receive(:open_document)
          cli.send(:clean_up)
        end

        context 'user is on a mac' do
          before { stub_const('RUBY_PLATFORM', 'darwin') }

          it 'opens the file using the open command' do
            expect(cli).to receive(:system).with("open #{document_name}.pdf")
            cli.send(:clean_up)
          end
        end

        context 'user is on linux' do
          before { stub_const('RUBY_PLATFORM', 'linux') }

          it 'opens the file using the xdg-open command' do
            expect(cli).to \
              receive(:system).with("xdg-open #{document_name}.pdf")
            cli.send(:clean_up)
          end
        end

        context 'user is on windows' do
          before { stub_const('RUBY_PLATFORM', 'windows') }

          it 'opens the file using the cmd command' do
            expect(cli).to \
              receive(:system).with("cmd /c \"start #{document_name}.pdf\"")
            cli.send(:clean_up)
          end
        end

        context 'user is on an unknown operating system' do
          before { stub_const('RUBY_PLATFORM', 'unknown') }

          it 'prints a message telling the user to open the file' do
            # including calls to #puts in #clean_up
            expect(cli).to receive(:puts).exactly(3).times
            cli.send(:clean_up)
          end
        end
      end

      context 'user does not allow script to open PDF' do
        before { allow(cli).to receive(:permission_granted?).and_return(false) }

        it 'does not attempt to open the document' do
          expect(cli).to_not receive(:open_document)
          cli.send(:clean_up)
        end
      end
    end
  end

  describe Decodable do
    let(:decoder) { Object.new.extend(Decodable) }

    describe '.d' do
      it 'wraps the Base64.strict_decode64 method' do
        expect(Base64).to receive(:strict_decode64).with('Hello')
        decoder.d('Hello')
      end
    end
  end


  describe Resource do
    describe '.for' do
      let(:image) { double('image') }
      let(:hash) do
        {
          image: "http://farm.staticflickr.com/example.jpg",
          link: "d3d3LmV4YW1wbGUuY29t",
          width: 35,
          height: 35,
          fit: [35, 35],
          align: "center",
          move_up: 35,
          bars: 3,
          size: 40,
          origin: 415,
          at: 280
        }
      end
      let(:resource) { Resource.for(hash) }

      before do
        allow(Resource).to receive(:open).with(hash[:image]).and_return(image)
      end

      it 'has an image' do
        expect(resource.image).to eq(image)
      end

      it 'has a link' do
        expect(resource.link).to eq('www.example.com')
      end

      it 'has a width' do
        expect(resource.width).to eq(35)
      end

      it 'has a height' do
        expect(resource.height).to eq(35)
      end

      it 'has a fit' do
        expect(resource.fit).to eq([35, 35])
      end

      it 'has an align' do
        expect(resource.align).to eq(:center)
      end

      it 'has a move_up' do
        expect(resource.move_up).to eq(35)
      end

      it 'has a bars' do
        expect(resource.bars).to eq(3)
      end

      it 'has a size' do
        expect(resource.size).to eq(40)
      end

      it 'has an origin' do
        expect(resource.origin).to eq(415)
      end

      it 'has an at ' do
        expect(resource.at).to eq(280)
      end
    end
  end

  describe ResumeGenerator do
    describe 'constants' do
      let(:version) { ResumeGenerator.const_get('VERSION') }
      let(:document_name) { ResumeGenerator.const_get('DOCUMENT_NAME') }

      it 'has a VERSION constant' do
        expect(version).to_not be_empty
      end

      it 'has a DOCUMENT_NAME constant' do
        expect(document_name).to_not be_empty
      end
    end
  end

  describe Resume do
    gem 'prawn', '1.0.0'
    require 'prawn'

    # Link points to a 1x1 pixel placeholder to not slow down test suite
    # Couldn't send Prawn::Document an image test double
    let(:placeholder_image) do
      open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
    end

    describe ".generate" do
      let(:filename) { "#{ResumeGenerator::DOCUMENT_NAME}.pdf" }

      before do
        allow(Resume).to \
          receive(:background_image).and_return(placeholder_image)
        allow(Resource).to \
          receive(:open).with(anything).and_return(placeholder_image)
        Resume.generate
      end
      after { File.delete(filename) }

      it 'generates a pdf resume' do
        expect(File.exist?(filename)).to be true
      end
    end

    describe ".background_image" do
      before do
        allow(Resume).to \
          receive(:open).with(anything).and_return(placeholder_image)
      end

      it 'has a background image' do
        expect(Resume.background_image).to eq(placeholder_image)
      end
    end
  end
end
