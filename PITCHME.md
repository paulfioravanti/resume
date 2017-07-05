# **Resume** _as_
# **`$CODE`**

Note:
Hi everyone, my name is Paul and..

---

# _I made my resume with_
# **Ruby** ♥

Note:
...I made my resume with Ruby.
So, where previously I would send a prospective employer a...

---

# _Document_

Note:
...resume document, I'd now send them a...

---

# _Document_
# ⬇
# Program

Note:
...Ruby program...

---

# _Document_
# ⬆
# Program

Note:
... which then generates a resume document.

---

# WHY?

Note:
Why even make this?

---

# 🍤

Note:
- Initially I just wanted to use it to learn how to use the Prawn gem to generate PDFs
- But, after a while I figured I could actually make it into something I could use because...

---

# _Not fun to_
# read _or_ write

Note:
- ...resumes aren't so much fun to read or write
- Hopefully through making my resume be a bit more fun for me to write using Ruby, I'd make it a bit more fun to read for others.
- This would then hopefully have the follow-on effects of making it more likely that...

---

# _Actually be_
# read

Note:
- ...the resume would actually be read since some minor effort would be needed to generate it
- The reader would then be somewhat invested in finding out what this script that they'd been given actually creates

---

# Positive
# _Response_

Note:
Through that, it would hopefully be more likely to get a positive response...

---

# _Gets an_
# Interview

Note:
- ...that in the end gets me an interview
- and I think that unless you're already very well-known, your resume really is your personal sales tool
- That tool's utmost objective is to get you an interview as soon as possible

---

# Skip
# _Coding Test_

Note:
- As a bonus, it would be nice to be able to skip any coding tests, as the resume itself would also be a code sample

---

# _**Components**_

Note:
- The codebase of the resume has changed greatly as I've tinkered with it
- But as it stands now, it consists of two major components:

---

# CLI

Note:
The CLI program, which handles user input, and what needs to happen before and after the resume gets created...

---

# Resume
# Generator

Note:
...and the resume itself, which is generated by Prawn.

---

# _**Content**_

Note:
- There is no content in the resume app at all
- so you can't just open up the code to read the resume instead of generating the PDF
- Rather, the content comes from...

---

# Text ➡ JSON ➡  _Github_

Note:
- JSON files hosted in the project Github repo
- All text there is encoded in Base64, so you really do need to generate the resume to read any of its content

---

# Images ➡ _Dropbox_

Note: And image assets are hosted on my Dropbox account

---

# _`/tmp`_

Note:
- When you run the resume for the first time, it downloads all those files and stores them in your system tmp directory.
- So, when you've generated the resume once, it will generate quicker subsequent times (or until your system clears out your tmp directory).

---

# _**Structure**_

Note:
- The directory structure of the resume is pretty much standard for any Ruby project, which is fine for development
- But I didn't want to package up multiple files when sending the resume to someone

---

# `$rake`

Note:
- So, there is a `rake` task that reads in all the files, writes them to a single file (which I call the one-sheet resume).
- Doing this means that I can just have a single Ruby file attachment to any email I send.

---

# _**Design**_

Note:
I am not a designer, but a few things I did want to have in the resume are:

---

# 2 Pages _Max_

Note:
- 2 Pages maximum because of low attention spans

---

# Buzzword _Bingo_

Note:
Buzzword Bingo up the top to make it easier to matchmake my abilities with the position requirements...

---

# LinkedIn-_Style_

Note:
...and LinkedIn-style position and education listings with links and images

---

# Demo

Note:
- Generate resume: `$ bin/resume`
- Run specs `$ rspec spec/`
  - 100% test coverage
    - Grade A on Code Climate
    - Run `rake` task
    - Open resume.rb file to show code modularisation, even in a single file
    - Create Japanese resume

---

## _`paulfioravanti/resume`_

Note:
- The resume is available on Github if you want to adapt it to your needs or are just curious and want a play
- The main takeaway point I'd like to emphasise is that creating your resume doesn't have to be a chore
- It can be as fun and rewarding as any other software that you write
- And that's all the better if doing something a bit different can help you in your jobhunting as well

---?image=https://www.dropbox.com/s/5w770gu31uw33l9/nekobus_headshot.jpeg?dl=1&size=contain
# **Thanks!**
# _`@paulfioravanti`_

Note:
Questions