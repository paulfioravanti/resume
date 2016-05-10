# Resume

[![Build Status](https://travis-ci.org/paulfioravanti/resume.svg?branch=master)](https://travis-ci.org/paulfioravanti/resume) [![Test Coverage](https://codeclimate.com/github/paulfioravanti/resume/badges/coverage.svg)](https://codeclimate.com/github/paulfioravanti/resume) [![Code Climate](https://codeclimate.com/github/paulfioravanti/resume/badges/gpa.svg)](https://codeclimate.com/github/paulfioravanti/resume) [![Dependency Status](https://gemnasium.com/paulfioravanti/resume.svg)](https://gemnasium.com/paulfioravanti/resume)

This is a Ruby CLI application that generates my resume.  I made it in order to teach myself a bit about the Ruby PDF generation library [Prawn](https://github.com/prawnpdf/prawn).  [Railscast #153](http://railscasts.com/episodes/153-pdfs-with-prawn-revised) is also a good resource for learning about it.

Text is deliberately obfuscated in the JSON files with [Base64](http://ruby-doc.org/stdlib-2.3.0/libdoc/base64/rdoc/Base64.html) to encourage people to generate the PDF rather than attempt to read the resume content there.

## Usage

Generate the resume in the following languages:

:uk: `$ bin/resume`  
:it: `$ bin/resume -l it`  
:jp: `$ bin/resume -l ja`

Run `$ bin/resume -h` to see all the options.

Run the specs:

    $ bundle install
    $ rspec spec/

If you have SimpleCov installed, view the test coverage report located at:

    coverage/index.html

Generate the "one-sheet" version of the resume (the whole app and specs in a single file).  
If I sent my resume to you directly, it would have been generated from this `rake` task:

    $ rake resume

### Dependencies

- Ruby 2.3.1
- I18n 0.7, Prawn 2.1.0 and Prawn-Table 0.2.2 (if you don't have the specific versions of the gems, you will be prompted to install them)
- RSpec 3.4, if you want to run the specs
- SimpleCov 0.11 if you want to view the coverage report locally

### Presentation

I did a lightning talk about this project at the Ruby on Rails Oceania Meetup
on 10 May 2016.  
The slide deck can be found [here](https://speakerdeck.com/paulfioravanti/resume-as-code).

### Issues:

- I would have liked to use the Arial font for English, but since it's not included with Prawn by default and I did not want to include any external fonts when generating the resume in English (Japanese required external fonts), I stuck with Helvetica
- It doesn't seem possible yet in Prawn to make an embedded image a clickable link.  Until support is possible (if ever), I've simply pulled in images from Flickr and overlaid a transparent text link on top to simulate clicking an image.  More discussion on this issue is at [this StackOverflow thread](http://stackoverflow.com/q/8289031/567863).

### Social

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>
