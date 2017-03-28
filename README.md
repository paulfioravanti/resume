# Resume :page_facing_up:

<table>
  <tr>
    <td>
      Build Status
    </td>
    <td>
      <a href="https://travis-ci.org/paulfioravanti/resume">
        <img src="https://travis-ci.org/paulfioravanti/resume.svg?branch=master" alt="Build Status" />
      </a>
      <a href="https://ci.appveyor.com/project/paulfioravanti/resume">
        <img src="https://ci.appveyor.com/api/projects/status/5v5426as3y3o9f6e/branch/master?svg=true" alt="Build Status" />
      </a>
      <a href="https://semaphoreci.com/paulfioravanti/resume">
        <img src="https://semaphoreci.com/api/v1/paulfioravanti/resume/branches/master/shields_badge.svg" alt="Build Status" />
      </a>
      <a href="https://circleci.com/gh/paulfioravanti/resume">
        <img src="https://circleci.com/gh/paulfioravanti/resume/tree/master.svg?style=shield" alt="Build Status" />
      </a>
      <a href="https://app.codeship.com/projects/50157">
        <img src="https://codeship.com/projects/db246630-58c8-0132-9e3b-069770f0649f/status?branch=master" alt="Build Status" />
      </a>
      <a href="https://scrutinizer-ci.com/g/paulfioravanti/resume">
        <img src="https://scrutinizer-ci.com/g/paulfioravanti/resume/badges/build.png?b=master" alt="Build Status" />
      </a>
    </td>
  </tr>
  <tr>
    <td>
      Code Coverage
    </td>
    <td>
      <a href="https://codeclimate.com/github/paulfioravanti/resume">
        <img src="https://codeclimate.com/github/paulfioravanti/resume/badges/coverage.svg" alt="Code Climate Coverage" />
      </a>
      <a href="https://codecov.io/gh/paulfioravanti/resume">
        <img src="https://codecov.io/gh/paulfioravanti/resume/branch/master/graph/badge.svg" alt="Codecov Coverage" />
      </a>
      <a href="https://coveralls.io/github/paulfioravanti/resume?branch=master">
        <img src="https://coveralls.io/repos/github/paulfioravanti/resume/badge.svg?branch=master" alt="Coveralls Coverage" />
      </a>
      <a href="https://scrutinizer-ci.com/g/paulfioravanti/resume">
        <img src="https://scrutinizer-ci.com/g/paulfioravanti/resume/badges/coverage.png?b=master" alt="Scrutinizer Coverage" />
      </a>
    </td>
  </tr>
  <tr>
    <td>
      Code Quality
    </td>
    <td>
      <a href="https://codeclimate.com/github/paulfioravanti/resume">
        <img src="https://codeclimate.com/github/paulfioravanti/resume/badges/gpa.svg" alt="Code Climate" />
      </a>
      <a href="https://codebeat.co/projects/github-com-paulfioravanti-resume">
        <img src="https://codebeat.co/badges/177b8978-ac33-4ec7-9534-765df49a0ef5" alt="Codebeat Badge" />
      </a>
      <a href="https://scrutinizer-ci.com/g/paulfioravanti/resume">
        <img src="https://scrutinizer-ci.com/g/paulfioravanti/resume/badges/quality-score.png?b=master" alt="Scrutinizer Status" />
      </a>
      <a href="https://hakiri.io/github/paulfioravanti/resume/master">
        <img src="https://hakiri.io/github/paulfioravanti/resume/master.svg" alt="Hakiri Status" />
      </a>
    </td>
  </tr>
  <tr>
    <td>
      Dependencies
    </td>
    <td>
      <a href="https://gemnasium.com/paulfioravanti/resume">
        <img src="https://gemnasium.com/paulfioravanti/resume.svg" alt="Dependency Status">
      </a>
    </td>
  </tr>
</table>

This is a Ruby CLI application that generates my resume.  I made it in order
to teach myself a bit about the Ruby PDF generation library
[Prawn](https://github.com/prawnpdf/prawn).
[Railscast #153](http://railscasts.com/episodes/153-pdfs-with-prawn-revised)
is also a good resource for learning about it.

Text is deliberately obfuscated in the JSON files that contain the resume content
with [Base64](http://ruby-doc.org/stdlib-2.3.0/libdoc/base64/rdoc/Base64.html)
to ensure people generate the PDF in order to be able to read anything.

## Setup :paperclip:

    $ git clone https://github.com/paulfioravanti/resume.git
    $ cd resume
    $ bundle install

## Usage :pencil2:

Generate the resume in the following languages:

:uk: `$ bin/resume`<br />
:it: `$ bin/resume -l it`<br />
:jp: `$ bin/resume -l ja`

Run `$ bin/resume -h` to see all the options.

Run the specs:

    $ bin/rspec

View the Simplecov test coverage report:

    $ open coverage/index.html

### One Sheet Resume :memo:

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

If there are ever any errors or issues related to the downloading of remote
assets that cause the resume to not be able to be generated, you can run the
following `rake` task to delete all resume-related assets from the local tmpdir:

    $ bin/rake resume:delete_assets

### Dependencies :fried_shrimp:

- Ruby 2.4.1
- I18n, Prawn and Prawn-Table (if you don't have the specific
  versions of the gems, you will be prompted to install them)
- RSpec, if you want to run the specs

### Presentation :zap:

I did a lightning talk about this project at the
[Ruby on Rails Oceania Meetup](https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/)
on [10 May 2016](https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/events/228886775/).<br />
The slide deck can be found [here](https://speakerdeck.com/paulfioravanti/resume-as-code).

### Issues :confused:

- It doesn't seem possible yet in Prawn to make an embedded image a clickable
  link.  Until support is possible (if ever), I've simply pulled in images from
  Dropbox and overlaid a transparent text link on top to simulate clicking an
  image.  More discussion on this issue is at
  [this StackOverflow thread](http://stackoverflow.com/q/8289031/567863).

### Social :neckbeard:

[![Contact](https://img.shields.io/badge/contact-%40paulfioravanti-blue.svg)](https://twitter.com/paulfioravanti)

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>
