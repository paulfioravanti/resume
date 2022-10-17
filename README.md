# Resume

<a href="https://travis-ci.com/paulfioravanti/resume">
  <img src="https://travis-ci.com/paulfioravanti/resume.svg?branch=master" alt="Build Status" />
</a>
<a href="https://codeclimate.com/github/paulfioravanti/resume">
  <img src="https://codeclimate.com/github/paulfioravanti/resume/badges/gpa.svg" alt="Code Climate" />
</a>
<a href="https://inch-ci.org/github/paulfioravanti/resume?branch=master">
  <img src="http://inch-ci.org/github/paulfioravanti/resume.svg?branch=master" alt="Documentation Status" />
</a>
<a href="https://snyk.io/test/github/paulfioravanti/resume">
  <img src="https://snyk.io/test/github/paulfioravanti/resume/badge.svg" alt="Known Vulnerabilities" data-canonical-src="https://snyk.io/test/github/paulfioravanti/resume" style="max-width:100%;" />
</a>
<br />
<br />

This is a [Ruby][] command line interface (CLI) application that generates my
resume.  I made it in order to teach myself a bit about the Ruby [PDF][]
generation library [Prawn][]. [Railscast #153][] is also a good resource for
learning about it.

Text is deliberately obfuscated in the [JSON][] files that contain the resume
content with [Base64][] to ensure people generate the PDF in order to be able
to read anything.

## Blog Post and Presentation

I wrote a companion blog post for this project:

- _[Resume as Code][]_

It outlines some reasons for making it, as well as some of the technical
challenges and quirks.

I also did a lightning talk about this project at the [Ruby on Rails Oceania
Meetup][roro] on [10 May 2016][roro-20160510] ([slide deck][speakerdeck]). No
video of the talk exists, unfortunately. Perhaps I will re-record it again some
time...

## Setup

```sh
git clone https://github.com/paulfioravanti/resume.git
cd resume
bundle install
```

## Dependencies

- Ruby 3.1.2
- [i18n][], Prawn and [Prawn-Table][] (if you don't have the specific versions
  of the gems, you will be prompted to install them)
- [RSpec][], if you want to run the tests

## Usage

### Generate Resume

Generate the resume in the following languages:

:uk: `bin/resume`<br />
:it: `bin/resume -l it`<br />
:jp: `bin/resume -l ja`

Help: `bin/resume -h`

### Tests

Run the tests:

```sh
bin/rspec
```

### Coverage Report

View the [Simplecov][] test coverage report:

```sh
open coverage/index.html
```

### Documentation

Generate the [YARD][] documentation:

```sh
bin/yardoc
```

## One Sheet Resume

Generate the "one sheet" version of the resume (the whole app and specs in a
single file called `resume.rb`).<br />

### Create

If I sent my resume to you directly, it would have been generated from
this `rake` task:

```sh
bin/rake resume
```

### Generate One Sheet

The resume PDF can be generated from the one sheet in a similar way as the
CLI app:

:uk: `ruby resume.rb`<br />
:it: `ruby resume.rb -l it`<br />
:jp: `ruby resume.rb -l ja`

### One Sheet Specs

The specs can also be run directly on the one sheet resume:

```sh
rspec resume.rb
```

### Delete Assets

If there are ever any errors or issues related to the downloading of remote
assets that cause the resume to not be able to be generated, you can run the
following `rake` task to delete all resume-related assets from the local tmpdir:

```sh
bin/rake resume:delete_assets
```

## Issues

- It doesn't seem possible yet in Prawn to make an embedded image a clickable
  link.  Until support is possible (if ever), I've simply pulled in images from
  Dropbox and overlaid a transparent text link on top to simulate clicking an
  image.  More discussion on this issue is at
  [this StackOverflow thread][stackoverflow-transparent-link].

## Social

[![Contact][twitter-badge]][twitter-url]<br />
[![Stack Overflow][stackoverflow-badge]][stackoverflow-url]

[Base64]: http://ruby-doc.org/stdlib-2.3.0/libdoc/base64/rdoc/Base64.html
[i18n]: https://github.com/ruby-i18n/i18n
[JSON]: https://en.wikipedia.org/wiki/JSON
[PDF]: https://en.wikipedia.org/wiki/PDF
[Prawn]: https://github.com/prawnpdf/prawn
[Prawn-Table]: https://github.com/prawnpdf/prawn-table
[Railscast #153]: http://railscasts.com/episodes/153-pdfs-with-prawn-revised
[Resume as Code]: https://paulfioravanti.com/blog/2019/06/22/resume-as-code/
[roro]: https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/
[roro-20160510]: https://www.meetup.com/Ruby-On-Rails-Oceania-Sydney/events/228886775/
[RSpec]: https://github.com/rspec/rspec
[Ruby]: https://www.ruby-lang.org/en/
[Simplecov]: https://github.com/colszowka/simplecov
[speakerdeck]: https://speakerdeck.com/paulfioravanti/resume-as-code
[stackoverflow-badge]: http://stackoverflow.com/users/flair/567863.png
[stackoverflow-transparent-link]: http://stackoverflow.com/q/8289031/567863
[stackoverflow-url]: http://stackoverflow.com/users/567863/paul-fioravanti
[twitter-badge]: https://img.shields.io/badge/contact-%40paulfioravanti-blue.svg
[twitter-url]: https://twitter.com/paulfioravanti
[YARD]: https://yardoc.org/
