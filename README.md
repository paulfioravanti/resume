# Resume

This is a short Ruby script that generates my resume.  I made it in order to teach myself a bit about the Ruby PDF generation library [Prawn](https://github.com/prawnpdf/prawn).  [Railscast #153](http://railscasts.com/episodes/153-pdfs-with-prawn-revised) is also a good resource for learning about it.

Text is deliberately obfuscated with [Base64](http://ruby-doc.org/stdlib-2.0/libdoc/base64/rdoc/Base64.html) to encourage people to generate the PDF and not read the resume content from within the code.

## Usage

    $ ruby resume.rb

If you don't have the Prawn gem installed, you will be asked for permission to install it.

### Dependencies

- Ruby 1.9.2 or higher
- Prawn 1.0.0.rc2 or higher

### Issues:

- I would have liked to use the Arial font, but since it's not included with Prawn by default and I did not want to include any external fonts, I stuck with Helvetica
- It doesn't seem possible yet in Prawn to make an embedded image a clickable link.  Until support is possible, I've simply pulled in images from Flickr and placed a text image underneath.  There's an [open bounty on the topic at StackOverflow](http://stackoverflow.com/q/8289031/567863).

### Social

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>

[![endorse](http://api.coderwall.com/pfioravanti/endorsecount.png)](http://coderwall.com/pfioravanti)