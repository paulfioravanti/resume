# Resume

[![Build Status](https://travis-ci.org/paulfioravanti/resume.png?branch=master)](https://travis-ci.org/paulfioravanti/resume) [![Test Coverage](https://codeclimate.com/github/paulfioravanti/resume/badges/coverage.svg)](https://codeclimate.com/github/paulfioravanti/resume) [![Code Climate](https://codeclimate.com/github/paulfioravanti/resume.png)](https://codeclimate.com/github/paulfioravanti/resume) [![Dependency Status](https://gemnasium.com/paulfioravanti/resume.png)](https://gemnasium.com/paulfioravanti/resume)

This is a short Ruby script that generates my resume.  I made it in order to teach myself a bit about the Ruby PDF generation library [Prawn](https://github.com/prawnpdf/prawn).  [Railscast #153](http://railscasts.com/episodes/153-pdfs-with-prawn-revised) is also a good resource for learning about it.

Text is deliberately obfuscated with [Base64](http://ruby-doc.org/stdlib-2.0/libdoc/base64/rdoc/Base64.html) to encourage people to generate the PDF and not read the resume content from within the code.

## Usage

Install the gems (primarily if you want to run the specs):

    $ bundle install

Generate the resume:

    $ bin/resume

Run the specs:

    $ rspec spec/

If you have SimpleCov installed, view the test coverage report located at:

    coverage/index.html

### Dependencies

- Ruby 1.9.2 or higher (1.8.7 will not work)
- Prawn 1.2.1 and Prawn-Table 0.1.0 (if you don't have either specific versions of the gems, you will be asked for permission to install them)
- RSpec 3.0, if you want to run the specs
- SimpleCov 0.9.0 if you want to view the coverage report locally

### Issues:

- I would have liked to use the Arial font, but since it's not included with Prawn by default and I did not want to include any external fonts, I stuck with Helvetica
- It doesn't seem possible yet in Prawn to make an embedded image a clickable link.  Until support is possible (if ever), I've simply pulled in images from Flickr and overlaid a transparent text link on top to simulate clicking an image.  More discussion on this issue is at [this StackOverflow thread](http://stackoverflow.com/q/8289031/567863).

### Social

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>

[![endorse](http://api.coderwall.com/pfioravanti/endorsecount.png)](http://coderwall.com/pfioravanti)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/paulfioravanti/resume/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

