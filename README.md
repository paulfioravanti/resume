# Resume

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
      Code Quality
    </td>
    <td>
      <a href="https://codeclimate.com/github/paulfioravanti/resume">
        <img src="https://codeclimate.com/github/paulfioravanti/resume/badges/gpa.svg" alt="Code Climate" />
      </a>
      <a href="https://codebeat.co/projects/github-com-paulfioravanti-resume">
        <img src="https://codebeat.co/badges/177b8978-ac33-4ec7-9534-765df49a0ef5" alt="Codebeat Badge" />
      </a>
      <a href="https://www.codacy.com/app/paulfioravanti/resume">
        <img src="https://api.codacy.com/project/badge/Grade/f20808b9a57a42d1a06d821bca5df9df"/>
      </a>
      <a href="https://scrutinizer-ci.com/g/paulfioravanti/resume">
        <img src="https://scrutinizer-ci.com/g/paulfioravanti/resume/badges/quality-score.png?b=master" alt="Scrutinizer Status" />
      </a>
      <a href="https://hakiri.io/github/paulfioravanti/resume/master">
        <img src="https://hakiri.io/github/paulfioravanti/resume/master.svg" alt="Hakiri Status" />
      </a>
      <a href="https://snyk.io/test/github/paulfioravanti/resume">
        <img src="https://snyk.io/test/github/paulfioravanti/resume/badge.svg" alt="Known Vulnerabilities" data-canonical-src="https://snyk.io/test/github/paulfioravanti/resume" style="max-width:100%;">
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
      <a href="https://www.codacy.com/app/paulfioravanti/resume">
        <img src="https://api.codacy.com/project/badge/Coverage/f20808b9a57a42d1a06d821bca5df9df"/>
      </a>
      <a href="https://coveralls.io/github/paulfioravanti/resume?branch=master">
        <img src="https://coveralls.io/repos/github/paulfioravanti/resume/badge.svg?branch=master" alt="Coveralls Coverage" />
      </a>
      <a href="https://scrutinizer-ci.com/g/paulfioravanti/resume">
        <img src="https://scrutinizer-ci.com/g/paulfioravanti/resume/badges/coverage.png?b=master" alt="Scrutinizer Coverage" />
      </a>
      <a href="https://inch-ci.org/github/paulfioravanti/resume?branch=master">
        <img src="http://inch-ci.org/github/paulfioravanti/resume.svg?branch=master" alt="Documentation Status" />
      </a>
    </td>
  </tr>
  <tr>
    <td>
      Other
    </td>
    <td>
      <a href="https://gemnasium.com/paulfioravanti/resume">
        <img src="https://gemnasium.com/paulfioravanti/resume.svg" alt="Dependency Status">
      </a>
      <a href="https://git.legal/projects/3664">
        <img src="https://git.legal/projects/3664/badge.svg?key=c393d7902601db754c83" alt="Number of libraries approved">
      </a>
      <a href="https://gitpitch.com/paulfioravanti/resume">
        <img src="https://gitpitch.com/assets/badge.svg" alt="GitPitch">
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

## Setup

    $ git clone https://github.com/paulfioravanti/resume.git
    $ cd resume
    $ bundle install

## Usage

### Generate

Generate the resume in the following languages:

:uk: `$ bin/resume`<br />
:it: `$ bin/resume -l it`<br />
:jp: `$ bin/resume -l ja`

Help: `$ bin/resume -h`

### Specs

Run the specs:

    $ bin/rspec

### Coverage Report

View the Simplecov test coverage report:

    $ open coverage/index.html

### Documentation

Generate the YARD documentation:

    $ bin/yardoc

## One Sheet Resume

Generate the "one sheet" version of the resume (the whole app and specs in a
single file called `resume.rb`).<br />

### Create

If I sent my resume to you directly, it would have been generated from
this `rake` task:

    $ bin/rake resume

### Generate

The resume PDF can be generated from the one sheet in a similar way as the
CLI app:

:uk: `$ ruby resume.rb`<br />
:it: `$ ruby resume.rb -l it`<br />
:jp: `$ ruby resume.rb -l ja`

### Specs

The specs can also be run directly on the one sheet resume:

    $ rspec resume.rb

### Delete Assets

If there are ever any errors or issues related to the downloading of remote
assets that cause the resume to not be able to be generated, you can run the
following `rake` task to delete all resume-related assets from the local tmpdir:

    $ bin/rake resume:delete_assets

## Dependencies

- Ruby 2.4.2
- I18n, Prawn and Prawn-Table (if you don't have the specific
  versions of the gems, you will be prompted to install them)
- RSpec, if you want to run the specs

## Presentation

I did a lightning talk about this project at the
[Ruby on Rails Oceania Meetup](https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/)
on [10 May 2016](https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/events/228886775/).<br />
The slide deck can be found [here](https://speakerdeck.com/paulfioravanti/resume-as-code).

Just for fun, I created a [GitPitch](https://gitpitch.com/) version of the
presentation as well, which can be viewed
[here](https://gitpitch.com/paulfioravanti/resume) (or with presenter notes
visible [here](https://gitpitch.com/paulfioravanti/resume?n=true)).

## Issues

- It doesn't seem possible yet in Prawn to make an embedded image a clickable
  link.  Until support is possible (if ever), I've simply pulled in images from
  Dropbox and overlaid a transparent text link on top to simulate clicking an
  image.  More discussion on this issue is at
  [this StackOverflow thread](http://stackoverflow.com/q/8289031/567863).

## Executable

Using [Ruby Packer](https://github.com/pmq20/ruby-packer), an executable can
be created for the resume.  However, this is _very experimental_, doesn't really
work properly, and is only documented here as an interesting curiosity.

### Install Ruby Packer

Follow the instructions on the repository's README file. I'll focus on the
[MacOS installation instructions](https://github.com/pmq20/ruby-packer#install-on-macos).

In the `resume` directory, perform the following:

```sh
$ brew install squashfs
$ curl -L http://enclose.io/rubyc/rubyc-darwin-x64.gz | gunzip > rubyc
$ chmod +x rubyc
```

### Generate resume first

Before attempting to do anything with any executable, make sure that you've
generated the resume in your target language already so that image and font
assets are stored in your local tmp folder and no further connections need to be
made in order to fetch them.  This is because of an
[open issue regarding SSL with Enclose.IO's Ruby executable](https://github.com/pmq20/ruby-packer/issues/10).

If this issue gets solved, maybe the executable can be used to go fetch assets
as well.

### Generate and run resume executable

As of this writing, [Enclose.IO's Ruby executable](http://enclose.io/ruby) only
goes up to version 2.4.1. Therefore, similar to the
[AppVeyor build](https://www.appveyor.com/docs/build-environment/#ruby), we
will have to override the specified Ruby version with an `ENV` variable when
generating and running the resume executable.

**Generate executable** (here named `resume.out`):

```sh
$ CUSTOM_RUBY_VERSION="2.4.1" ./rubyc bin/resume -o resume.out
```

**Run resume executable**:

:uk: `$ CUSTOM_RUBY_VERSION="2.4.1" ./resume.out`<br />
:it: `$ CUSTOM_RUBY_VERSION="2.4.1" ./resume.out -l it`<br />
:jp: `$ CUSTOM_RUBY_VERSION="2.4.1" ./resume.out -l ja`<br />

So, yes, more of a curiosity here than anything really useful.

## Social

[![Contact](https://img.shields.io/badge/contact-%40paulfioravanti-blue.svg)](https://twitter.com/paulfioravanti)

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>
