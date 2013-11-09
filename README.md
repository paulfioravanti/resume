# Resume

This is a short Ruby script that generates my resume.  I made it in order to teach myself a bit about the Ruby PDF generation library [Prawn](https://github.com/prawnpdf/prawn).  [Railscast #153](http://railscasts.com/episodes/153-pdfs-with-prawn-revised) is also a good resource for learning about it.

Text is deliberately obfuscated with [Base64](http://ruby-doc.org/stdlib-2.0/libdoc/base64/rdoc/Base64.html) to encourage people to generate the PDF and not read the resume content from within the code.

## Usage

Install the gems (primarily if you want to run the specs):

    $ bundle install

Both commands below produce the same result of my PDF resume.  The only difference is that one runs the componentised code in the `lib` directory, and the other runs just the one Ruby script, which contains all the classes and modules from `lib` in one file.

### Run the resume generator under the `lib` folder:

    $ bin/resume

### Run the 'one-sheet' resume script:

    $ ruby resume.rb

### Run the specs on the resume generator under the `lib` folder:

    $ rspec spec/

### Run the specs on the 'one-sheet' resume script:

    $ rspec resume.rb

### Dependencies

- Ruby 1.9.2 or higher (1.8.7 will not work)
- Prawn 1.0.0.rc2 or higher (if you don't have the Prawn version 1.0.0.rc2 gem installed, you will be asked for permission to install it)
- RSpec 2.14.7 or higher, if you want to run the specs

### Issues:

- I would have liked to use the Arial font, but since it's not included with Prawn by default and I did not want to include any external fonts, I stuck with Helvetica
- It doesn't seem possible yet in Prawn to make an embedded image a clickable link.  Until support is possible (if ever), I've simply pulled in images from Flickr and overlaid a transparent text link on top to simulate clicking an image.  More discussion on this issue is at [this StackOverflow thread](http://stackoverflow.com/q/8289031/567863).

### Social

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>

[![endorse](http://api.coderwall.com/pfioravanti/endorsecount.png)](http://coderwall.com/pfioravanti)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/paulfioravanti/resume/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

