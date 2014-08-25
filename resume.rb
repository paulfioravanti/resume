# encoding: utf-8
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
require 'base64'
require 'open-uri'
require 'json'

module ResumeGenerator
  # This const would only ever be defined when this file's specs
  # are run in the repo with the structured version of the resume.
  VERSION = '0.2' unless const_defined?(:VERSION)
  DOCUMENT_NAME = 'Resume'

  module Colourable
    private

    def colourize(text, colour_code:)
      "\e[#{colour_code}m#{text}\e[0m"
    end

    def red(text)
      colourize(text, colour_code: 31)
    end

    def yellow(text)
      colourize(text, colour_code: 33)
    end

    def green(text)
      colourize(text, colour_code: 32)
    end

    def cyan(text)
      colourize(text, colour_code: 36)
    end
  end

  module Messages
    include Colourable

    def inform_creation_of_social_media_links
      puts 'Creating social media links...'
    end

    def inform_creation_of_technical_skills
      puts 'Creating technical skills section...'
    end

    def inform_creation_of_employment_history
      puts 'Creating employment history section...'
    end

    def inform_creation_of_education_history
      puts 'Creating education history section...'
    end

    private

    def request_gem_installation
      print yellow(
        "May I please install the following Ruby gems:\n"\
        "- prawn 1.2.1\n"\
        "- prawn-table 0.1.0\n"\
        "in order to help me generate a PDF (Y/N)? "\
      )
    end

    def thank_user_for_permission
      puts green('Thank you kindly :-)')
    end

    def inform_start_of_gem_installation
      puts 'Installing required gems...'
    end

    def inform_start_of_resume_generation
      puts "Generating PDF. This shouldn't take longer than a few seconds..."
    end

    def inform_of_failure_to_generate_resume
      puts red(
        "Sorry, I won't be able to generate a PDF\n"\
        "without these specific gem versions.\n"\
        "Please ask me directly for a PDF copy of my resume."
      )
    end

    def inform_of_successful_resume_generation
      puts green('Resume generated successfully.')
    end

    def print_thank_you_message
      puts cyan(
        "Thanks for looking at my resume. I hope to hear from you soon!\n"\
        "Resume.pdf has been generated in the same directory as the script."
      )
    end

    def request_to_open_resume
      print yellow 'Would you like me to open the resume for you (Y/N)? '
    end

    def request_user_to_open_document
      puts yellow(
        "Sorry, I can't figure out how to open the resume on\n"\
        "this computer. Please open it yourself."
      )
    end

    def inform_of_successful_gem_installation
      puts green('Gems successfully installed.')
    end

    def inform_of_gem_installation_failure
      puts red(
        "Sorry, for some reason I wasn't able to\n"\
        "install one or more required gems.\n"\
        "Either try again or ask me directly for a PDF copy of "\
        "my resume."
      )
    end
  end

  class CLI
    include Messages

    def start
      check_ability_to_generate_resume
      generate_resume
      clean_up
    end

    private

    def check_ability_to_generate_resume
      return if required_gems_available?(
        'prawn' => '1.2.1', 'prawn-table' => '0.1.0'
      )
      request_gem_installation
      if permission_granted?
        thank_user_for_permission
        inform_start_of_gem_installation
        install_gem
      else
        inform_of_failure_to_generate_resume
        exit
      end
    end

    def generate_resume
      gem 'prawn', '1.2.1'
      gem 'prawn-table', '0.1.0'
      require 'prawn'
      require 'prawn/table'
      inform_start_of_resume_generation
      Resume.generate(self)
    end

    def clean_up
      inform_of_successful_resume_generation
      request_to_open_resume
      open_document if permission_granted?
      print_thank_you_message
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
        request_user_to_open_document
      end
    end

    def required_gems_available?(gems)
      gems.each do |name, version|
        if Gem::Specification.find_by_name(name).version <
          Gem::Version.new(version)
          return false
        end
      end
      true
    rescue Gem::LoadError # gem not installed
      false
    end

    def permission_granted?
      gets.chomp.match(%r{\Ay(es)?\z}i)
    end

    def install_gem
      begin
        system('gem install prawn -v 1.2.1')
        system('gem install prawn-table -v 0.1.0')
        inform_of_successful_gem_installation
        # Reset the dir and path values so Prawn can be required
        Gem.clear_paths
      rescue
        inform_of_gem_installation_failure
        exit
      end
    end
  end

  module Decodable
    # This is just a helper method due to the sheer amount of decoding that
    # occurs throughout the code
    def d(string)
      Base64.strict_decode64(string)
    end
  end

  class Resource
    extend Decodable

    attr_reader :image, :link, :width, :height, :fit, :align,
                :move_up, :bars, :size, :origin, :at

    def self.for(params)
      params[:image] = open(params[:image])
      params[:link] = d(params[:link])
      params[:align] = params[:align].to_sym
      new(params)
    end

    private

    def initialize(params)
      params.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end

  # Bag O' Methods Module.
  module Utilities
    private

    def social_media_icon_set_for(social_media)
      resources = resources_for(social_media)
      x_position = 0
      social_media_icon_for(resources.first, x_position)
      x_position += 45
      resources[1..-1].each do |resource|
        move_up 46.25
        social_media_icon_for(resource, x_position)
        x_position += 45
      end
    end

    def resources_for(social_media)
      social_media[:resources].values.map do |social_medium|
        Resource.for(social_medium.merge(social_media[:properties]))
      end
    end

    def social_media_icon_for(resource, x_position)
      bounding_box([x_position, cursor], width: resource.width) do
        image(resource.image, fit: resource.fit, align: resource.align)
        move_up 35
        transparent_link(resource)
      end
    end

    def showcase_table_for(skills)
      table_data = skills[:content].reduce([]) do |data, entry|
        data << [d(entry.first), d(entry.last)]
      end
      table(table_data, skills[:properties])
    end

    def listing_for(entry)
      header_for(entry)
      logo_link_for(entry)
      details_for(entry) if entry.has_key?(:summary)
    end

    def header_for(entry)
      move_down entry[:y_header_start] || 15
      if entry[:at]
        text_box_header_for(entry)
      else
        text_header_for(entry)
      end
    end

    def details_for(entry)
      move_down entry[:y_details_start] || 10
      summary(entry[:summary])
      profile(entry[:profile])
    end

    def summary(string)
      text(d(string), inline_format: true)
    end

    def profile(items)
      return unless items
      table_data = items.reduce([]) do |data, item|
        data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [], height: 21 })
    end

    def text_header_for(entry)
      formatted_text_entry_for(d(entry[:position]), 12)
      formatted_text_entry_for(d(entry[:organisation]), 11)
      formatted_text_period_and_location(
        d(entry[:period]),
        d(entry[:location][:name]),
        d(entry[:location][:link])
      )
    end

    def text_box_header_for(entry)
      at = entry[:at]
      formatted_text_box_entry_for(d(entry[:position]), 12, at, 14)
      formatted_text_box_entry_for(d(entry[:organisation]), 11, at, 13)
      formatted_text_box_period_and_location(
        d(entry[:period]),
        d(entry[:location][:name]),
        d(entry[:location][:link]),
        at
      )
    end

    def logo_link_for(entry)
      logo = Resource.for(entry[:logo].merge(at: entry[:at]))
      move_up entry[:y_logo_start] || 40
      bounding_box([logo.origin, cursor],
        width: logo.width, height: logo.height) do
        image logo.image, fit: logo.fit, align: logo.align
        move_up logo.move_up
        transparent_link(logo)
      end
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

    def formatted_text_entry_for(item, size)
      formatted_text(
        [formatted_entry_args_for(item, size)]
      )
    end

    def formatted_text_box_entry_for(item, size, at, value)
      formatted_text_box(
        [formatted_entry_args_for(item, size)], at: [at, cursor]
      )
      move_down value
    end

    def formatted_entry_args_for(string, size)
      { text: string, styles: [:bold], size: size }
    end

    def formatted_text_period_and_location(period, name, link)
      formatted_text(
        period_and_location_args_for(period, name, link)
      )
    end

    def formatted_text_box_period_and_location(period, name, link, at)
      formatted_text_box(
        period_and_location_args_for(period, name, link),
        at: [at, cursor]
      )
    end

    def period_and_location_args_for(period, name, link)
      [
        { text: period, color: '666666', size: 10 },
        { text: name, link: link, color: '666666', size: 10 }
      ]
    end
  end

  module ResumeHelper
    include Decodable, Utilities

    RESUME = JSON.parse(
      open('resources/resume.json').read,
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
          { text: d(headline[:ruby]), color: '85200C' },
          { text: d(headline[:other]) }
        ],
        size: 14
      )
    end

    def social_media_icons
      move_down 5
      social_media_icon_set_for(RESUME[:social_media])
      stroke_horizontal_rule { color '666666' }
    end

    def technical_skills
      heading d("VGVjaG5pY2FsIFNraWxscw==")
      move_down 5
      showcase_table_for(RESUME[:tech_skills])
    end

    def employment_history
      heading d('RW1wbG95bWVudCBIaXN0b3J5')
      entries = RESUME[:entries]
      [:rc, :fl, :gw, :rnt, :sra, :jet, :satc].each do |entry|
        listing_for(entries[entry])
      end
      move_down 10
      stroke_horizontal_rule { color '666666' }
    end

    def education_history
      heading d('RWR1Y2F0aW9u')
      entries = RESUME[:entries]
      [:mit, :bib, :ryu, :tafe].each do |entry|
        listing_for(entries[entry])
      end
    end
  end

  class Resume
    def self.generate(cli)
      Prawn::Document.class_eval do
        include ResumeHelper
      end
      Prawn::Document.generate("#{DOCUMENT_NAME}.pdf", pdf_options) do
        name
        headline
        cli.inform_creation_of_social_media_links
        social_media_icons
        cli.inform_creation_of_technical_skills
        technical_skills
        cli.inform_creation_of_employment_history
        employment_history
        cli.inform_creation_of_education_history
        education_history
      end
    end

    def self.pdf_options
      {
        margin_top: 0.75,
        margin_bottom: 0.75,
        margin_left: 1,
        margin_right: 1,
        background: background_image,
        repeat: true
      }
    end
    private_class_method :pdf_options
  end
end

if __FILE__ == $0
  ResumeGenerator::CLI.new.start
end

module ResumeGenerator
  require 'rspec'

  RSpec.configure { |c| c.disable_monkey_patching! }

  # Note: There are some incomprehensible hacks regarding `.and_call_original`
  # that were put in here so that SimpleCov would actually see these methods as
  # having been touched during testing.
  RSpec.describe CLI do
    let(:cli) { CLI.new }
    # stub out the innards of permission_granted? (i.e. calls chained to #gets)
    # so it doesn't interfere with spec operation
    let(:user_input) { double('user_input', chomp: self, match: true) }

    before do
      allow(cli).to receive(:gets).and_return(user_input)
      allow(cli).to receive(:system) # stub out `gem install ...`
      allow($stdout).to receive(:write) # suppress message cruft from stdout
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
      let(:prawn_table_gem) { double('prawn_table_gem') }

      before do
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn').and_return(prawn_gem)
        allow(Gem::Specification).to \
          receive(:find_by_name).with('prawn-table').and_return(prawn_table_gem)
        allow(Gem::Version).to receive(:new).and_return(1.2, 0.1)
      end

      context 'user has the expected gems installed' do
        before do
          allow(prawn_gem).to receive(:version).and_return(1.2)
          allow(prawn_table_gem).to receive(:version).and_return(0.1)
        end

        specify 'user is not asked to install any gems' do
          expect(cli).to_not receive(:permission_granted?)
          cli.send(:check_ability_to_generate_resume)
        end
      end

      context 'user has an expected gem installed, but an unexpected version' do
        before do
          allow(prawn_gem).to receive(:version).and_return(0)
        end

        specify 'user is asked to install gems' do
          expect(cli).to receive(:request_gem_installation)
          cli.send(:check_ability_to_generate_resume)
        end
      end

      context 'user does not have a required gem installed' do
        before do
          allow(Gem::Specification).to \
            receive(:find_by_name).and_raise(Gem::LoadError)
        end

        specify 'user is asked to install the required gems' do
          expect(cli).to receive(:request_gem_installation)
          cli.send(:check_ability_to_generate_resume)
        end

        context 'user agrees to install the gems' do
          before do
            allow(cli).to receive(:permission_granted?).and_return(true)
          end

          it 'executes installation' do
            expect(cli).to receive(:thank_user_for_permission)
            expect(cli).to receive(:inform_start_of_gem_installation)
            expect(cli).to receive(:inform_of_successful_gem_installation)
            cli.send(:check_ability_to_generate_resume)
          end

          context 'gems are unable to be installed' do
            before { allow(cli).to receive(:system).and_raise }

            it 'prints an error message and exits' do
              expect(cli).to receive(:thank_user_for_permission)
              expect(cli).to receive(:inform_start_of_gem_installation)
              expect(cli).to \
                receive(:inform_of_gem_installation_failure).and_call_original
              expect(cli).to receive(:exit)
              cli.send(:check_ability_to_generate_resume)
            end
          end
        end

        context 'when user does not agree to install the gems' do
          before do
            allow(cli).to receive(:permission_granted?).and_return(false)
          end

          it 'prints an error message and exits' do
            expect(cli).to \
              receive(:inform_of_failure_to_generate_resume).and_call_original
            expect(cli).to receive(:exit)
            cli.send(:check_ability_to_generate_resume)
          end
        end
      end
    end

    describe 'generating the PDF' do
      before do
        allow(cli).to receive(:gem).with('prawn', '1.2.1')
        allow(cli).to receive(:gem).with('prawn-table', '0.1.0')
        allow(cli).to receive(:require).with('prawn')
        allow(cli).to receive(:require).with('prawn/table')
      end

      it 'tells the PDF to generate itself' do
        expect(cli).to \
          receive(:inform_start_of_resume_generation).and_call_original
        expect(Resume).to receive(:generate)
        cli.send(:generate_resume)
      end
    end

    describe 'post-PDF generation' do
      it 'shows a success message and asks to open the resume' do
        expect(cli).to receive(:inform_of_successful_resume_generation)
        expect(cli).to receive(:request_to_open_resume)
        cli.send(:clean_up)
      end

      context 'user allows the script to open the PDF' do
        let(:document_name) { ResumeGenerator::DOCUMENT_NAME }

        before { allow(cli).to receive(:permission_granted?).and_return(true) }

        it 'attempts to open the document' do
          expect(cli).to receive(:open_document)
          expect(cli).to receive(:print_thank_you_message)
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
            expect(cli).to \
              receive(:request_user_to_open_document).and_call_original
            cli.send(:clean_up)
          end
        end
      end

      context 'user does not allow script to open PDF' do
        before { allow(cli).to receive(:permission_granted?).and_return(false) }

        it 'does not attempt to open the document' do
          expect(cli).to_not receive(:open_document)
          expect(cli).to receive(:print_thank_you_message)
          cli.send(:clean_up)
        end
      end
    end
  end

  RSpec.describe Decodable do
    let(:decoder) { Object.new.extend(Decodable) }

    describe '.d' do
      it 'wraps the Base64.strict_decode64 method' do
        expect(Base64).to receive(:strict_decode64).with('Hello')
        decoder.d('Hello')
      end
    end
  end

  RSpec.describe Messages do
    let(:messagable) { Class.new { include Messages }.new }
    let(:outputting_message) { -> { message } }

    describe '#inform_creation_of_social_media_links' do
      let(:message) { messagable.inform_creation_of_social_media_links }

      it 'outputs a message to stdout' do
        expect(outputting_message).to output.to_stdout
      end
    end

    describe '#inform_creation_of_technical_skills' do
      let(:message) { messagable.inform_creation_of_technical_skills }

      it 'outputs a message to stdout' do
        expect(outputting_message).to output.to_stdout
      end
    end

    describe '#inform_creation_of_employment_history' do
      let(:message) { messagable.inform_creation_of_employment_history }

      it 'outputs a message to stdout' do
        expect(outputting_message).to output.to_stdout
      end
    end

    describe '#inform_creation_of_education_history' do
      let(:message) { messagable.inform_creation_of_education_history }

      it 'outputs a message to stdout' do
        expect(outputting_message).to output.to_stdout
      end
    end
  end

  RSpec.describe Resource do
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

      it 'has an at value' do
        expect(resource.at).to eq(280)
      end
    end
  end

  RSpec.describe ResumeGenerator do
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

  RSpec.describe Resume do
    gem 'prawn', '1.2.1'
    gem 'prawn-table', '0.1.0'
    require 'prawn'
    require 'prawn/table'

    # Link points to a 1x1 pixel placeholder to not slow down test suite
    # Couldn't send Prawn::Document an image test double
    let(:placeholder_image) do
      open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
    end

    before do
      allow($stdout).to receive(:write) # suppress message cruft from stdout
    end

    describe ".generate" do
      let(:filename) { "#{ResumeGenerator::DOCUMENT_NAME}.pdf" }
      let(:cli) { double('cli').as_null_object }

      before do
        allow(Resume).to \
          receive(:background_image).and_return(placeholder_image)
        allow(Resource).to \
          receive(:open).with(anything).and_return(placeholder_image)
        Resume.generate(cli)
      end
      after { File.delete(filename) }

      it 'generates a pdf resume and notifies the creation of each part' do
        expect(cli).to have_received(:inform_creation_of_social_media_links)
        expect(cli).to have_received(:inform_creation_of_employment_history)
        expect(cli).to have_received(:inform_creation_of_education_history)
        expect(File.exist?(filename)).to be true
      end
    end

    describe ".background_image" do
      before do
        allow(Resume).to \
          receive(:open).with(anything).and_return(placeholder_image)
      end

      it 'fetches the background image of the resume' do
        expect(Resume.background_image).to eq(placeholder_image)
      end
    end
  end
end
