# Resume

[![Build Status](https://travis-ci.org/paulfioravanti/resume.svg?branch=master)](https://travis-ci.org/paulfioravanti/resume)
[![Test Coverage](https://codeclimate.com/github/paulfioravanti/resume/badges/coverage.svg)](https://codeclimate.com/github/paulfioravanti/resume)
[![Code Climate](https://codeclimate.com/github/paulfioravanti/resume/badges/gpa.svg)](https://codeclimate.com/github/paulfioravanti/resume)
[![Codebeat Badge](https://codebeat.co/badges/177b8978-ac33-4ec7-9534-765df49a0ef5)](https://codebeat.co/projects/github-com-paulfioravanti-resume)
[![PullReview Stats](https://www.pullreview.com/github/paulfioravanti/resume/badges/master.svg?)](https://www.pullreview.com/github/paulfioravanti/resume/reviews/master)
[![Dependency Status](https://gemnasium.com/paulfioravanti/resume.svg)](https://gemnasium.com/paulfioravanti/resume)

This is a Ruby CLI application that generates my resume.  I made it in order
to teach myself a bit about the Ruby PDF generation library
[Prawn](https://github.com/prawnpdf/prawn).
[Railscast #153](http://railscasts.com/episodes/153-pdfs-with-prawn-revised)
is also a good resource for learning about it.

Text is deliberately obfuscated in the JSON files that contain the resume content
with [Base64](http://ruby-doc.org/stdlib-2.3.0/libdoc/base64/rdoc/Base64.html)
to ensure people generate the PDF in order to be able to read anything.

## Setup

    $ git clone https://github.com/paulfioravanti/resume.git
    $ cd resume
    $ bundle install

## Usage

Generate the resume in the following languages:

:uk: `$ bin/resume`<br />
:it: `$ bin/resume -l it`<br />
:jp: `$ bin/resume -l ja`

Run `$ bin/resume -h` to see all the options.

Run the specs:

    $ bin/rspec

If you have SimpleCov installed, view the test coverage report:

    $ open coverage/index.html

### One Sheet Resume

Generate the "one sheet" version of the resume (the whole app and specs in a
single file called `resume.rb`).<br />
If I sent my resume to you directly, it would have been generated from
this `rake` task:

    $ bin/rake resume

The resume PDF can be generated from the one sheet in a similar way as the
CLI app:

:uk: `$ ruby resume.rb`<br />
:it: `$ ruby resume.rb -l it`<br />
:jp: `$ ruby resume.rb -l ja`

The specs can also be run directly on the one sheet resume:

    $ rspec resume.rb

### Dependencies

- Ruby 2.4.0
- I18n 0.7, Prawn 2.1.0 and Prawn-Table 0.2.2 (if you don't have the specific
  versions of the gems, you will be prompted to install them)
- RSpec 3.5, if you want to run the specs
- SimpleCov 0.12 if you want to view the coverage report locally

### Presentation

I did a lightning talk about this project at the
[Ruby on Rails Oceania Meetup](https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/)
on [10 May 2016](https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/events/228886775/).<br />
The slide deck can be found [here](https://speakerdeck.com/paulfioravanti/resume-as-code).

### Issues:

- It doesn't seem possible yet in Prawn to make an embedded image a clickable
  link.  Until support is possible (if ever), I've simply pulled in images from
  Dropbox and overlaid a transparent text link on top to simulate clicking an
  image.  More discussion on this issue is at
  [this StackOverflow thread](http://stackoverflow.com/q/8289031/567863).

### Social

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>
