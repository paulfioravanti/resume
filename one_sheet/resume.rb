# encoding: utf-8
################################################################################
### This resume lives online at https://github.com/paulfioravanti/resume
### in case you want to see a more readable, structured version of the files.
###
### Instructions:
### 1. Make sure you run this with Ruby 2.2.2
###
### 2. Please let the script install some Prawn gems for PDF generation if you
###    don't have them already (prawn and prawn-table)
###    Otherwise, contact me directly for the PDF file.
###
### 3. The script will pull down some small images from Flickr, so please ensure
###    you have an internet connection.
###
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
require 'optparse'
require 'socket'
require 'forwardable'

module Resume
  # These consts would only ever be defined when this file's specs
  # are run in the repo with the structured version of the resume: an edge case
  VERSION = '0.6' unless const_defined?(:VERSION)
  PRAWN_VERSION = '2.0.1' unless const_defined?(:PRAWN_VERSION)
  PRAWN_TABLE_VERSION = '0.2.1' unless const_defined?(:PRAWN_TABLE_VERSION)

  module CLI
    module Colours
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
      include Colours

      def self.included(base)
        base.send(:attr_reader, :messages)
      end

      def initialize_messages
        @messages = {
          en: {
            inform_creation_of_social_media_links:
              'Creating social media links...',
            inform_creation_of_technical_skills:
              'Creating technical skills section...',
            inform_creation_of_employment_history:
              'Creating employment history section...',
            inform_creation_of_education_history:
              'Creating education history section...',
            request_gem_installation:
              "May I please install the following Ruby gems:\n"\
              "- prawn #{PRAWN_VERSION}\n"\
              "- prawn-table #{PRAWN_TABLE_VERSION}\n"\
              "in order to help me generate a PDF (Y/N)? ",
            thank_user_for_permission:
              'Thank you kindly :-)',
            inform_start_of_gem_installation:
              'Installing required gems...',
            inform_start_of_resume_generation:
              "Generating PDF. This shouldn't take longer than a few seconds...",
            inform_of_failure_to_generate_resume:
              "Sorry, I won't be able to generate a PDF\n"\
              "without these specific gem versions.\n"\
              "Please ask me directly for a PDF copy of my resume.",
            inform_of_successful_resume_generation:
              'Resume generated successfully.',
            request_to_open_resume:
              'Would you like me to open the resume for you (Y/N)? ',
            request_user_to_open_document:
              "Sorry, I can't figure out how to open the resume on\n"\
              "this computer. Please open it yourself.",
            inform_of_successful_gem_installation:
              'Gems successfully installed.',
            inform_of_gem_installation_failure:
              "Sorry, for some reason I wasn't able to\n"\
              "install one or more required gems.\n"\
              "Either try again or ask me directly for a PDF copy of "\
              "my resume.",
            inform_of_network_connection_issue:
              "Sorry, it seems I can't get an outside connection.\n"\
              "Please check your internet settings and try again."
          }
        }[locale]
      end

      def thank_user_for_permission
        puts green(messages[__method__])
      end

      def inform_start_of_gem_installation
        puts messages[__method__]
      end

      def inform_creation_of_social_media_links
        puts messages[__method__]
      end

      def inform_creation_of_technical_skills
        puts messages[__method__]
      end

      def inform_creation_of_employment_history
        puts messages[__method__]
      end

      def inform_creation_of_education_history
        puts messages[__method__]
      end

      def inform_of_network_connection_issue
        puts red(messages[__method__])
      end

      def inform_of_successful_gem_installation
        puts green(messages[__method__])
      end

      def inform_of_gem_installation_failure
        puts red(messages[__method__])
      end

      def request_user_to_open_document
        puts yellow(messages[__method__])
      end

      private

      def request_gem_installation
        print yellow(messages[__method__])
      end

      def inform_start_of_resume_generation
        puts messages[__method__]
      end

      def inform_of_failure_to_generate_resume
        puts red(messages[__method__])
      end

      def inform_of_successful_resume_generation
        puts green(messages[__method__])
      end

      def print_thank_you_message
        # This is in its own method because it needs to know about the filename
        # which is only known once we know the resume can be generated and
        # its data is fetched.
        puts cyan(
          {
            en: "Thanks for looking at my resume."\
                "I hope to hear from you soon!\n"\
                "#{filename} has been generated in the same\n"\
                "directory you ran this script."
          }[locale]
        )
      end

      def request_to_open_resume
        print yellow(messages[__method__])
      end
    end

    class ArgumentParser
      include Colours

      attr_reader :supported_locales, :parser
      attr_accessor :locale

      def initialize
        @supported_locales = [:en]
        @parser = initialize_parser
      end

      def parse
        parser.parse!(ARGV)
        self.locale ||= :en
      rescue OptionParser::InvalidOption
        inform_of_invalid_options
        exit
      rescue OptionParser::MissingArgument
        inform_of_missing_arguments
        exit
      end

      private

      def initialize_parser
        OptionParser.new do |opts|
          opts.banner = 'Usage: ruby resume.rb [options]'
          opts.separator ''
          opts.separator 'Specific options:'

          locale_option(opts)

          opts.separator ''
          opts.separator 'Common options:'

          help_option(opts)
          version_option(opts)
        end
      end

      def locale_option(opts)
        opts.on('-l', '--locale LOCALE',
                'Select the locale of the resume') do |locale|
          if supported_locales.include?(locale.to_sym)
            self.locale = locale.to_sym
          else
            inform_locale_not_supported(locale)
            exit
          end
        end
      end

      def help_option(opts)
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end

      def version_option(opts)
        opts.on_tail('-v', '--version', 'Show version') do
          puts Resume::VERSION
          exit
        end
      end

      def inform_locale_not_supported(locale)
        puts red("Locale '#{locale}' is not supported.")
        puts yellow(
          "Supported locales are: #{supported_locales.join(', ')}"
        )
      end

      def inform_of_invalid_options
        puts red('You have some invalid options.')
        puts parser.help
      end

      def inform_of_missing_arguments
        puts red('You have a missing argument in one of your options.')
        puts parser.help
      end
    end

    class GemInstaller

      attr_reader :app, :gems

      def initialize(app)
        @app = app
        @gems = {
          'prawn' => PRAWN_VERSION,
          'prawn-table' => PRAWN_TABLE_VERSION
        }
      end

      def installation_required?
        gems.each do |name, version|
          if Gem::Specification.find_by_name(name).version <
            Gem::Version.new(version)
            return true
          end
        end
        false
      rescue Gem::LoadError # gem not installed
        true
      end

      def install
        app.thank_user_for_permission
        app.inform_start_of_gem_installation
        if gems_successfully_installed?
          app.inform_of_successful_gem_installation
          # Reset the dir and path values so Prawn can be required
          Gem.clear_paths
        else
          app.inform_of_gem_installation_failure
          exit
        end
      end

      private

      def gems_successfully_installed?
        gems.all? do |gem, version|
          system('gem', 'install', gem, '-v', version)
        end
      end
    end

    class FileSystem
      def self.open_document(app)
        filename = app.filename
        case RUBY_PLATFORM
        when %r(darwin)
          system('open', filename)
        when %r(linux)
          system('xdg-open', filename)
        when %r(windows)
          system('cmd', '/c', "\"start #{filename}\"")
        else
          app.request_user_to_open_document
        end
      end
    end

    class Application
      include Messages
      extend Forwardable

      attr_reader :locale
      attr_accessor :filename

      def self.start
        parser = ArgumentParser.new
        parser.parse
        new(parser.locale).start
      end

      def initialize(locale)
        @locale = locale
        @installer = GemInstaller.new(self)
        initialize_messages
      end

      def_delegators :@installer, :installation_required?, :install

      def start
        install_gems if installation_required?
        generate_resume
        open_resume
      end

      private

      def install_gems
        request_gem_installation
        if permission_granted?
          install
        else
          inform_of_failure_to_generate_resume
          exit
        end
      end

      def generate_resume
        inform_start_of_resume_generation
        PDF::Document.generate(self)
        inform_of_successful_resume_generation
      end

      def open_resume
        request_to_open_resume
        FileSystem.open_document(self) if permission_granted?
        print_thank_you_message
      end

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end

  module Decoder
    def self.included(base)
      # Allow #d to be available on the class level as well
      base.extend self
    end
    # This is just a helper method due to the sheer amount of decoding that
    # occurs throughout the code
    def decode(string)
      # Force encoding to UTF-8 is needed for strings that had UTF-8 characters
      # in them when they were originally encoded
      Base64.strict_decode64(string).force_encoding('utf-8') if string
    end
    alias_method :d, :decode
  end

  module PDF
    class Font
      def self.configure(pdf, font)
        pdf.font font[:name]
      end
    end

    class Name
      include Decoder

      attr_reader :pdf, :font, :size, :text

      def self.generate(pdf, name)
        new(
          pdf,
          font: name[:font],
          size: name[:size],
          text: d(name[:text])
        ).generate
      end

      private_class_method :new

      def initialize(pdf, options)
        @pdf = pdf
        options.each do |attribute, value|
          instance_variable_set("@#{attribute}", value)
        end
      end

      def generate
        pdf.font(font, size: size) do
          pdf.text(text)
        end
      end
    end

    class Headline
      include Decoder

      attr_reader :pdf, :primary_text, :primary_colour, :secondary_text, :size

      def self.generate(pdf, headline)
        primary_header = headline[:primary]
        new(
          pdf,
          primary_text: d(primary_header[:text]),
          primary_colour: primary_header[:colour],
          secondary_text: d(headline[:secondary][:text]),
          size: headline[:size],
        ).generate
      end

      private_class_method :new

      def initialize(pdf, options)
        @pdf = pdf
        options.each do |attribute, value|
          instance_variable_set("@#{attribute}", value)
        end
      end

      def generate
        pdf.formatted_text(
          [
            { text: primary_text, color: primary_colour },
            { text: secondary_text }
          ],
          size: size
        )
      end
    end

    module TransparentLink
      private

      def transparent_link(pdf, logo)
        pdf.transparent(0) do
          pdf.formatted_text(
            [
              {
                text: '|' * logo.bars,
                size: logo.size,
                link: logo.link
              }
            ], align: logo.align
          )
        end
      end
    end

    class Logo
      include Decoder

      attr_reader :image, :link, :width, :height, :fit, :align,
                  :link_overlay_start, :bars, :size, :origin, :at, :y_start

      def self.for(data)
        data[:image] = open(data[:image])
        data[:link] = d(data[:link])
        data[:align] = data[:align].to_sym
        new(data)
      end

      private_class_method :new

      def initialize(data)
        data.each do |attribute, value|
          instance_variable_set("@#{attribute}", value)
        end
      end
    end

    class SocialMediaLogoSet
      include TransparentLink

      attr_reader :pdf, :x_position, :top_padding, :padded_logo_width,
                  :padded_logo_height, :horizontal_rule_colour, :logos
      attr_accessor :x_position

      def self.generate(pdf, logo_set)
        new(
          pdf,
          logo_set[:logos].values,
          logo_set[:logo_properties],
          x_position: logo_set[:x_position],
          top_padding: logo_set[:top_padding],
          padded_logo_width: logo_set[:padded_logo_width],
          padded_logo_height: logo_set[:padded_logo_height],
          horizontal_rule_colour: logo_set[:horizontal_rule_colour],
        ).generate
      end

      private_class_method :new

      def initialize(pdf, logo_values, logo_properties, options)
        @pdf = pdf
        @logos = logos_for(logo_values, logo_properties)
        options.each do |attribute, value|
          instance_variable_set("@#{attribute}", value)
        end
      end

      def generate
        pdf.move_down(top_padding)
        generate_logo_for(logos.first)
        logos[1..-1].each do |logo|
          pdf.move_up(padded_logo_height)
          generate_logo_for(logo)
        end
        pdf.stroke_horizontal_rule { color horizontal_rule_colour }
      end

      private

      def logos_for(logo_set, general_properties)
        logo_set.map do |logo_properties|
          Logo.for(logo_properties.merge(general_properties))
        end
      end

      def generate_logo_for(logo)
        pdf.bounding_box([x_position, pdf.cursor], width: logo.width) do
          pdf.image(
            logo.image,
            fit: logo.fit,
            align: logo.align
          )
          pdf.move_up logo.link_overlay_start
          transparent_link(pdf, logo)
        end
        self.x_position += padded_logo_width
      end
    end

    module Entry
      class Heading
        include Decoder

        attr_reader :pdf, :top_padding, :text, :styles, :colour

        def self.generate(pdf, heading)
          new(
            pdf,
            top_padding: heading[:top_padding],
            text: d(heading[:text]),
            styles: heading[:styles].map(&:to_sym),
            colour: heading[:colour]
          ).generate
        end

        private_class_method :new

        def initialize(pdf, options)
          @pdf = pdf
          options.each do |attribute, value|
            instance_variable_set("@#{attribute}", value)
          end
        end

        def generate
          pdf.move_down(top_padding)
          pdf.formatted_text([{
            text: text,
            styles: styles,
            color: colour
          }])
        end
      end

      class Header
        include Decoder

        attr_reader :pdf, :position, :organisation,
                    :period, :location, :at_x_position

        def self.generate(pdf, entry)
          new(
            pdf,
            entry[:position],
            entry[:organisation],
            entry[:period],
            entry[:location],
            at_x_position: entry[:at_x_position]
          ).generate
        end

        private_class_method :new

        def initialize(pdf, position, organisation, period, location, options)
          @pdf = pdf
          @position = position
          @organisation = organisation
          @period = period
          @location = location
          options.each do |attribute, value|
            instance_variable_set("@#{attribute}", value)
          end
        end

        def generate
          # Different rendering behaviour needed depending on whether the header
          # is being drawn from left to right on the page or specifically placed
          # at a location on the x-axis
          if at_x_position
            formatted_text_box_header
          else
            formatted_text_header
          end
        end

        private

        def formatted_text_header
          header_sections.each do |sections|
            pdf.formatted_text(
              sections.map { |section| properties_for(section) }
            )
          end
        end

        def formatted_text_box_header
          header_sections.each do |sections|
            pdf.formatted_text_box(
              sections.map { |section| properties_for(section) },
              at: [at_x_position, pdf.cursor]
            )
            pdf.move_down sections.first[:bottom_padding]
          end
        end

        def header_sections
          [[position], [organisation], [period, location]]
        end

        def properties_for(section)
          {
            text: d(section[:text]),
            styles: section[:styles].map(&:to_sym),
            size: section[:size],
            color: section[:colour],
            link: d(section[:link]),
          }
        end
      end

      class CompanyLogo
        include TransparentLink

        attr_reader :pdf, :logo

        def self.generate(pdf, data)
          logo = Logo.for(data[:logo])
          new(pdf, logo).generate
        end

        private_class_method :new

        def initialize(pdf, logo)
          @pdf = pdf
          @logo = logo
        end

        def generate
          pdf.move_up logo.y_start
          pdf.bounding_box(
            [logo.origin, pdf.cursor], width: logo.width, height: logo.height
          ) do
            render_image_link
          end
        end

        private

        def render_image_link
          pdf.image(logo.image, fit: logo.fit, align: logo.align)
          pdf.move_up logo.link_overlay_start
          transparent_link(pdf, logo)
        end
      end

      class Content
        include Decoder, TransparentLink

        attr_reader :pdf, :entry

        def self.generate(pdf, entry)
          new(pdf, entry).generate
        end

        private_class_method :new

        def initialize(pdf, entry)
          @pdf = pdf
          @entry = entry
        end

        def generate
          pdf.move_down entry[:top_padding]
          Header.generate(pdf, entry)
          CompanyLogo.generate(pdf, entry)
          details if entry.has_key?(:summary)
        end

        private

        def details
          pdf.move_down entry[:summary][:top_padding]
          summary
          profile
        end

        def summary
          pdf.text(d(entry[:summary][:text]), inline_format: true)
        end

        def profile
          items = entry[:profile]
          cell_style = entry[:cell_style]
          return unless items
          table_data = items.reduce([]) do |data, item|
            data << ['-', d(item)]
          end
          pdf.table(
            table_data,
            cell_style: {
              borders: cell_style[:borders],
              height: cell_style[:height]
            }
          )
        end
      end
    end

    class TechnicalSkills
      include Decoder

      attr_reader :pdf, :heading, :content

      def self.generate(pdf, data)
        new(pdf, data[:heading], data[:content]).generate
      end

      private_class_method :new

      def initialize(pdf, heading, content)
        @pdf = pdf
        @heading = heading
        @content = content
      end

      def generate
        generate_heading
        generate_content
      end

      private

      def generate_heading
        Entry::Heading.generate(pdf, heading)
      end

      def generate_content
        pdf.move_down content[:top_padding]
        skills = content[:skills].reduce([]) do |entries, entry|
          entries << [d(entry.first), d(entry.last)]
        end
        pdf.table(skills, content[:properties])
      end
    end

    class EmploymentHistory

      attr_reader :pdf, :heading, :content

      def self.generate(pdf, data)
        new(pdf, data[:heading], data[:content]).generate
      end

      private_class_method :new

      def initialize(pdf, heading, content)
        @pdf = pdf
        @heading = heading
        @content = content
      end

      def generate
        generate_heading
        generate_content
      end

      private

      def generate_heading
        Entry::Heading.generate(pdf, heading)
      end

      def generate_content
        content[:entries].values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
        pdf.move_down content[:bottom_padding]
        pdf.stroke_horizontal_rule { color content[:horizontal_rule_colour] }
      end
    end

    class EducationHistory

      attr_reader :pdf, :heading, :content

      def self.generate(pdf, data)
        new(pdf, data[:heading], data[:content]).generate
      end

      private_class_method :new

      def initialize(pdf, heading, content)
        @pdf = pdf
        @heading = heading
        @content = content
      end

      def generate
        generate_heading
        generate_content
      end

      private

      def generate_heading
        Entry::Heading.generate(pdf, heading)
      end

      def generate_content
        content[:entries].values.each do |entry|
          Entry::Content.generate(pdf, entry)
        end
      end
    end

    class Manifest
      def self.process(pdf, resume, app)
        Font.configure(pdf, resume[:font])
        Name.generate(pdf, resume[:name])
        Headline.generate(pdf, resume[:headline])
        app.inform_creation_of_social_media_links
        SocialMediaLogoSet.generate(
          pdf, resume[:social_media_logo_set]
        )
        app.inform_creation_of_technical_skills
        TechnicalSkills.generate(pdf, resume[:technical_skills])
        app.inform_creation_of_employment_history
        EmploymentHistory.generate(pdf, resume[:employment_history])
        app.inform_creation_of_education_history
        EducationHistory.generate(pdf, resume[:education_history])
      end
    end

    class Options
      include Decoder

      def self.for(resume)
        author = d(resume[:author])
        {
          margin_top: resume[:margin_top],
          margin_bottom: resume[:margin_bottom],
          margin_left: resume[:margin_left],
          margin_right: resume[:margin_right],
          background: open(resume[:background_image]),
          repeat: resume[:repeat],
          info: {
            Title: d(resume[:document_name]),
            Author: author,
            Creator: author,
            CreationDate: Time.now
          }
        }
      end
    end

    # This class cannot be declared as a Prawn::Document (ie inherit from it)
    # because at the time someone runs the script, it is not certain that they
    # have any of the required Prawn gems installed. Explicit declaration of
    # this kind of inheritance hierarchy in advance will result in an
    # uninitialized constant error.
    class Document
      include Decoder

      attr_reader :resume, :app

      def self.generate(app)
        locale = app.locale
        resume = JSON.parse(
          open(
            "https://raw.githubusercontent.com/paulfioravanti"\
            "/resume/master/resources/resume.#{locale}.json"
          ).read,
          symbolize_names: true
        )[:resume]
        app.filename =
          "#{d(resume[:document_name])}_#{locale}.pdf"
        new(resume, app).generate
      rescue SocketError
        app.inform_of_network_connection_issue
        exit
      end

      def initialize(resume, app)
        @resume = resume
        @app = app
      end

      def generate
        require 'prawn'
        require 'prawn/table'
        Prawn::Document.generate(app.filename, Options.for(resume)) do |pdf|
          pdf.instance_exec(resume, app) do |resume, app|
            Manifest.process(self, resume, app)
          end
        end
      end
    end
  end
end

if __FILE__ == $0
  Resume::CLI::Application.start
end

module Resume
  require 'rspec'

  RSpec.configure do |config|
    include Resume::CLI::Colours

    config.disable_monkey_patching!
    config.before(:suite) do
      begin
        require 'prawn'
        require 'prawn/table'
      rescue LoadError
        puts red(
          'You need to have the prawn and prawn-table gems installed in '\
          'order to run the specs.'
        )
        puts yellow(
          'Either install them yourself or run the resume and it will '\
          'install them for you.'
        )
        exit
      end
    end
  end

  RSpec.describe CLI::Application do
    let(:locale) { :en }

    before do
      allow($stdout).to receive(:write) # suppress message cruft from stdout
    end

    describe '.start' do
      let(:argument_parser) do
        double('argument_parser', parse: true, locale: locale)
      end
      let(:application) { double('application') }

      before do
        stub_const(
          'Resume::CLI::ArgumentParser',
          double('ArgumentParser', new: argument_parser)
        )
      end

      it 'creates a new Application, passing in the locale, and calls #start' do
        expect(described_class).to \
          receive(:new).with(locale).and_return(application)
        expect(application).to receive(:start)
        described_class.start
      end
    end

    describe '#start' do
      let(:application) { described_class.new(locale) }

      describe 'install gems' do
        let(:gem_installer) { double('gem_installer') }

        before do
          stub_const(
            'Resume::CLI::GemInstaller',
            double('GemInstaller', new: gem_installer)
          )
        end

        context 'when required gems are already installed' do
          before do
            allow(gem_installer).to \
              receive(:installation_required?).and_return(false)
            allow(application).to receive(:generate_resume)
            allow(application).to receive(:open_resume)
          end

          it 'does not request to install any gems' do
            expect(application).to_not receive(:install_gems)
            application.start
          end
        end

        context 'when the required gems are not installed' do
          before do
            allow(gem_installer).to \
              receive(:installation_required?).and_return(true)
            expect(application).to \
              receive(:request_gem_installation).and_call_original
          end

          context 'when permission is granted to install the gems' do
            before do
              allow(application).to receive(:gets).and_return('yes')
              allow(application).to receive(:generate_resume)
              allow(application).to receive(:open_resume)
            end

            it 'attempts to install the gems' do
              expect(gem_installer).to receive(:install)
              application.start
            end
          end

          context 'when permission is not granted to install the gems' do
            let(:starting_the_application) { -> { application.start } }

            before do
              allow(application).to receive(:gets).and_return('no')
            end

            it 'informs the user it cannot generate the resume and exits' do
              expect(application).to \
                receive(:inform_of_failure_to_generate_resume).and_call_original
              expect(starting_the_application).to raise_error(SystemExit)
            end
          end
        end
      end

      describe 'generate resume' do
        let(:resume) { double('PDF::Document') }

        before do
          allow(application).to receive(:install_gems)
          stub_const('Resume::PDF::Document', resume)
          allow(application).to receive(:open_resume)
        end

        it 'generates the resume' do
          expect(application).to \
            receive(:inform_start_of_resume_generation).and_call_original
          expect(resume).to receive(:generate).with(application)
          expect(application).to \
            receive(:inform_of_successful_resume_generation).and_call_original
          application.start
        end
      end

      describe 'open resume' do
        let(:file_system) { double('FileSystem') }

        before do
          stub_const('Resume::CLI::FileSystem', file_system)
          allow(application).to receive(:install_gems)
          allow(application).to receive(:generate_resume)
          expect(application).to \
            receive(:request_to_open_resume).and_call_original
        end

        context 'when permission is granted to open the resume' do
          before do
            allow(application).to receive(:gets).and_return('yes')
          end

          it 'attempts to open the resume and thanks the reader' do
            expect(file_system).to receive(:open_document).with(application)
            expect(application).to \
              receive(:print_thank_you_message).and_call_original
            application.start
          end
        end

        context 'when permission is not granted to open the resume' do
          before do
            allow(application).to receive(:gets).and_return('no')
          end

          it 'does not open the resume and thanks the reader' do
            expect(file_system).to_not receive(:open_document)
            expect(application).to \
              receive(:print_thank_you_message).and_call_original
            application.start
          end
        end
      end
    end
  end

  RSpec.describe CLI::ArgumentParser do
    let(:argument_parser) { described_class.new }

    describe '#parse' do
      before do
        allow($stdout).to receive(:write) # suppress message cruft from stdout
      end

      context 'when no locale option is specified' do
        let(:default_locale) { :en }

        before do
          stub_const('ARGV', [])
          argument_parser.parse
        end

        it 'sets the default locale' do
          expect(argument_parser.locale).to eq(default_locale)
        end
      end

      context 'when an unsupported locale option is specified' do
        let(:supported_locales) { [:en, :ja] }
        let(:unsupported_locale) { 'eo' }
        let(:parsing_options) { -> { argument_parser.parse } }

        before do
          allow(argument_parser).to \
            receive(:supported_locales).and_return(supported_locales)
          stub_const('ARGV', ['-l', unsupported_locale])
        end

        it 'informs the user of the supported locales and exits' do
          expect(argument_parser).to \
            receive(:inform_locale_not_supported).with(unsupported_locale).
              and_call_original
          expect(parsing_options).to raise_error(SystemExit)
        end
      end

      context 'when a supported locale option is specified' do
        let(:supported_locales) { [:en, :ja] }
        let(:supported_locale) { 'ja' }

        before do
          allow(argument_parser).to \
            receive(:supported_locales).and_return(supported_locales)
        end

        context 'using the abbreviated option name' do
          before do
            stub_const('ARGV', ['-l', supported_locale])
            argument_parser.parse
          end

          it 'sets the locale to the specified locale' do
            expect(argument_parser.locale).to eq(supported_locale.to_sym)
          end
        end

        context 'using the full option name' do
          before do
            stub_const('ARGV', ['--locale', supported_locale])
            argument_parser.parse
          end

          it 'sets the locale to the specified locale' do
            expect(argument_parser.locale).to eq(supported_locale.to_sym)
          end
        end
      end

      context 'when the version option is specified' do
        let(:version) { '1.0' }
        let(:parsing_options) { -> { argument_parser.parse } }

        before do
          stub_const('Resume::VERSION', version)
        end

        context 'using the abbreviated option name' do
          before do
            stub_const('ARGV', ['-v'])
          end

          it 'informs the user of the version number and exits' do
            expect(parsing_options).to \
              output(argument_parser.parser.version).to_stdout.and \
                raise_error(SystemExit)
          end
        end

        context 'using the full option name' do
          before do
            stub_const('ARGV', ['--version'])
          end

          it 'informs the user of the version number and exits' do
            expect(parsing_options).to \
              output(argument_parser.parser.version).to_stdout.and \
                raise_error(SystemExit)
          end
        end
      end

      context 'when the help option is specified' do
        let(:parsing_options) { -> { argument_parser.parse } }

        context 'using the abbreviated option name' do
          before do
            stub_const('ARGV', ['-h'])
          end

          it 'informs the user of the application options and exits' do
            expect(parsing_options).to \
              output(argument_parser.parser.help).to_stdout.and \
                raise_error(SystemExit)
          end
        end

        context 'using the full option name' do
          before do
            stub_const('ARGV', ['--help'])
          end

          it 'informs the user of the application options and exits' do
            expect(parsing_options).to \
              output(argument_parser.parser.help).to_stdout.and \
                raise_error(SystemExit)
          end
        end
      end

      context 'when an invalid option is specified' do
        let(:parsing_options) { -> { argument_parser.parse } }

        before do
          stub_const('ARGV', ['-invalid'])
        end

        it 'informs the user that there is an invalid option and exits' do
          expect(argument_parser).to \
            receive(:inform_of_invalid_options).and_call_original
          expect(parsing_options).to raise_error(SystemExit)
        end
      end

      context 'when a specified valid option has a missing argument' do
        let(:parsing_options) { -> { argument_parser.parse } }

        before do
          stub_const('ARGV', ['-l'])
        end

        it 'informs the user that there is a missing argument and exits' do
          expect(argument_parser).to \
            receive(:inform_of_missing_arguments).and_call_original
          expect(parsing_options).to raise_error(SystemExit)
        end
      end
    end
  end

  RSpec.describe CLI::FileSystem do
    describe '.open_document' do
      let(:resume_name) { 'My Resume.pdf' }
      let(:app) { CLI::Application.new(:en) }

      before do
        allow(app).to receive(:filename).and_return(resume_name)
        allow($stdout).to receive(:write) # suppress message cruft from stdout
      end

      context 'when run on Mac OS' do
        let(:mac_open_file_args) { ['open', app.filename] }

        before { stub_const('RUBY_PLATFORM', 'darwin') }

        it 'opens the file using the open command' do
          expect(described_class).to \
            receive(:system).with(*mac_open_file_args)
          described_class.open_document(app)
        end
      end

      context 'when run on Linux' do
        let(:linux_open_file_args) { ['xdg-open', app.filename] }

        before { stub_const('RUBY_PLATFORM', 'linux') }

        it 'opens the file using the xdg-open command' do
          expect(described_class).to \
            receive(:system).with(*linux_open_file_args)
          described_class.open_document(app)
        end
      end

      context 'when run on Windows' do
        let(:windows_open_file_args) do
          ['cmd', '/c', "\"start #{app.filename}\""]
        end

        before { stub_const('RUBY_PLATFORM', 'windows') }

        it 'opens the file using the cmd /c command' do
          expect(described_class).to \
            receive(:system).with(*windows_open_file_args)
          described_class.open_document(app)
        end
      end

      context 'when run on an unknown operating system' do
        before { stub_const('RUBY_PLATFORM', 'unknown') }

        it 'requests the user to open the document themself' do
          expect(app).to \
            receive(:request_user_to_open_document).and_call_original
          described_class.open_document(app)
        end
      end
    end
  end

  RSpec.describe CLI::GemInstaller do
    let(:app) { CLI::Application.new(:en) }
    let(:gem_installer) { described_class.new(app) }

    before do
      stub_const('PRAWN_VERSION', '2.0.1')
      stub_const('PRAWN_TABLE_VERSION', '0.2.1')
      allow($stdout).to receive(:write) # suppress message cruft from stdout
    end

    describe '#installation_required?' do
      let(:installation_required) { gem_installer.installation_required? }

      context 'when a required gem is not installed' do
        before do
          allow(Gem::Specification).to \
            receive(:find_by_name).and_raise(Gem::LoadError)
        end

        it 'returns true' do
          expect(installation_required).to be true
        end
      end

      context 'when the specific version of a required gem is not installed' do
        let(:prawn_gem) do
          double('prawn_gem', version: Gem::Version.new('1.0.0'))
        end

        before do
          allow(Gem::Specification).to \
            receive(:find_by_name).with('prawn').and_return(prawn_gem)
        end

        it 'returns true' do
          expect(installation_required).to be true
        end
      end

      context 'when all required gems are already installed' do
        let(:prawn_gem) do
          double(
            'prawn_gem',
            version: Gem::Version.new(PRAWN_VERSION)
          )
        end
        let(:prawn_table_gem) do
          double(
            'prawn_table_gem',
            version: Gem::Version.new(PRAWN_TABLE_VERSION)
          )
        end

        before do
          allow(Gem::Specification).to \
            receive(:find_by_name).with('prawn').
              and_return(prawn_gem)
          allow(Gem::Specification).to \
            receive(:find_by_name).with('prawn-table').
              and_return(prawn_table_gem)
        end

        it 'returns false' do
          expect(installation_required).to be false
        end
      end
    end

    describe '#install' do
      let(:install_prawn_args) do
        ['gem', 'install', 'prawn', '-v', PRAWN_VERSION]
      end

      before do
        expect(app).to \
          receive(:thank_user_for_permission).and_call_original
        expect(app).to \
          receive(:inform_start_of_gem_installation).and_call_original
      end

      context 'when the installation of a gem fails' do
        let(:installing_gems) { -> { gem_installer.install } }

        before do
          allow(gem_installer).to \
            receive(:system).with(*install_prawn_args).and_return(false)
        end

        it 'informs the user of the failure and exits' do
          expect(app).to \
            receive(:inform_of_gem_installation_failure).and_call_original
          expect(installing_gems).to raise_error(SystemExit)
        end
      end

      context 'when gems are able to be successfully installed' do
        let(:install_prawn_table_args) do
          ['gem', 'install', 'prawn-table', '-v', PRAWN_TABLE_VERSION]
        end

        before do
          allow(gem_installer).to \
            receive(:system).with(*install_prawn_args).and_return(true)
          allow(gem_installer).to \
            receive(:system).with(*install_prawn_table_args).and_return(true)
        end

        it 'informs the user of successful installation and resets gem paths' do
          expect(app).to \
            receive(:inform_of_successful_gem_installation).and_call_original
          expect(Gem).to receive(:clear_paths)
          gem_installer.install
        end
      end
    end
  end

  RSpec.describe PDF::Document do
    let(:locale) { :en }
    let(:app) { CLI::Application.new(locale) }
    let(:resume_data_path) do
      "https://raw.githubusercontent.com/paulfioravanti/resume/master/"\
      "resources/resume.#{app.locale}.json"
    end

    before do
      allow($stdout).to receive(:write) # suppress message cruft from stdout
    end

    describe '.generate' do
      context 'when a network connection cannot be made' do
        let(:generating_the_resume) { -> { described_class.generate(app) } }

        before do
          allow(JSON).to receive(:parse).and_raise(SocketError)
        end

        it 'informs the user of the network connection issue and exits' do
          expect(app).to \
            receive(:inform_of_network_connection_issue).and_call_original
          expect(generating_the_resume).to raise_error(SystemExit)
        end
      end

      context 'when a network connection can be made' do
        let(:document) { double('document') }
        let(:resume) { double('resume') }
        let(:resume_json) { double('resume_json') }
        let(:encoded_filename) { '3nC0D3d F1l3N4M3' }
        let(:decoded_filename) { 'Decoded Filename' }
        let(:app_filename) { "#{decoded_filename}_#{app.locale}.pdf" }

        before do
          allow(described_class).to \
            receive(:open).with(resume_data_path).and_return(resume_json)
          allow(resume_json).to receive(:read).and_return(resume_json)
          allow(JSON).to \
            receive(:parse).with(resume_json, { symbolize_names: true }).
              and_return(resume)
          allow(resume).to \
            receive(:[]).with(:resume).and_return(resume)
          allow(resume).to \
            receive(:[]).with(:document_name).and_return(encoded_filename)
          allow(described_class).to \
            receive(:d).with(encoded_filename).and_return(decoded_filename)
        end

        it 'creates a new Document and calls #generate' do
          expect(app).to receive(:filename=).with(app_filename)
          expect(described_class).to \
            receive(:new).with(resume, app).and_return(document)
          expect(document).to receive(:generate)
          described_class.generate(app)
        end
      end
    end

    describe '#generate' do
      # Link points to a 1x1 pixel placeholder to not slow down test suite
      # Couldn't send Prawn::Document an image test double
      let(:placeholder_image) do
        open('http://farm4.staticflickr.com/3722/10753699026_a1603247cf_m.jpg')
      end
      let(:resume) do
        JSON.parse(open(resume_data_path).read, symbolize_names: true)[:resume]
      end
      let(:filename) { 'My Resume.pdf' }
      let(:document) { described_class.new(resume, app) }

      before do
        allow(app).to receive(:filename).and_return(filename)
        allow(PDF::Logo).to \
          receive(:open).with(anything).and_return(placeholder_image)
        allow(PDF::Options).to \
          receive(:open).with(anything).and_return(placeholder_image)
      end
      after { File.delete(filename) }

      it 'generates a pdf resume and notifies the creation of each part' do
        expect(app).to \
          receive(:inform_creation_of_social_media_links).and_call_original
        expect(app).to \
          receive(:inform_creation_of_technical_skills).and_call_original
        expect(app).to \
          receive(:inform_creation_of_employment_history).and_call_original
        expect(app).to \
          receive(:inform_creation_of_education_history).and_call_original
        document.generate
        expect(File.exist?(filename)).to be true
      end
    end
  end
end
