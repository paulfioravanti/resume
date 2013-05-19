DOCUMENT_NAME = "Resume-Paul-Fioravanti"

################################################################################
### Script helper methods
################################################################################
def colorize(text, color_code); "\e[#{color_code}m#{text}\e[0m"; end
def red(text); colorize(text, 31); end
def yellow(text); colorize(text, 33); end
def green(text); colorize(text, 32); end
def cyan(text); colorize(text, 36); end

def yes?(response)
  response =~ %r(\Ay\z|\Ayes\z)i
end

def gem_available?(name)
   Gem::Specification.find_by_name(name)
rescue Gem::LoadError
   false
end

def open_document
  case RUBY_PLATFORM
  when %r(darwin)
    %x(open #{DOCUMENT_NAME}.pdf)
  when %r(linux)
    %x(xdg-open #{DOCUMENT_NAME}.pdf)
  when %r(windows)
    %x(cmd /c "start #{DOCUMENT_NAME}.pdf")
  else
    puts yellow "Sorry, I can't figure out how to open the resume on this "\
                "computer. Please open it yourself."
  end
end

def position_summary(qualification, organization, period)
  move_down 10
  formatted_text([
    { text: "#{qualification}\n", styles: [:bold] },
    { text: "#{organization}\n", styles: [:bold], size: 11 },
    { text: period, size: 10, color: "666666" }
  ])
end

def bullet_list(*items)
  table_data = []
  items.each do |item|
    table_data << ["•", item]
  end
  table(table_data, cell_style: { border_color: "FFFFFF" })
end

def link_list(*items)
  list = []
  items.each do |text, link|
    list << { text: text, link: link, styles: [:underline] }
    list << { text: "  " }
  end
  formatted_text(list, color: "0000FF")
end

################################################################################
### Get dependent gems if not available
################################################################################
unless gem_available?("prawn")
  print yellow "May I please install the prawn Ruby gem to help me generate "\
               "a PDF (Y/N)? "
  response = gets.chomp
  if yes?(response)
    puts green "Thank you kindly."
    puts "Installing prawn gem..."
    begin
      %x(gem install prawn --version '1.0.0.rc2')
    rescue
      puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
               "Either try again or ask Paul directly for a PDF copy of his "\
               "resume."
      exit
    end
    puts green "Prawn gem successfully installed."
    Gem.clear_paths
  else
    puts red "Sorry, I won't be able to generate a PDF without this gem.\n"\
             "Please ask Paul directly for a PDF copy of his resume."
    exit
  end
end

################################################################################
### Generate document
################################################################################
require "prawn"
Prawn::Document.generate("#{DOCUMENT_NAME}.pdf",
                         margin_top: 0.75,
                         margin_bottom: 0.75,
                         margin_left: 1,
                         margin_right: 1) do
  font("Times-Roman", size: 20) { text "Paul Fioravanti" }
  formatted_text(
    [
      { text: "Ruby Developer ", color: "85200C" },
      { text: "and Information Technology Services Professional"}
    ],
    size: 14
  )

  move_down 5
  link_list(
    ["Email", "mailto:paul.fioravanti@gmail.com"],
    ["LinkedIn", "http://linkedin.com/in/paulfioravanti"],
    ["Github", "http://github.com/paulfioravanti"],
    ["StackOverflow", "http://stackoverflow.com/users/567863/paul-fioravanti"],
    ["Twitter", "https://twitter.com/pefioravanti"],
    ["SpeakerDeck", "https://speakerdeck.com/paulfioravanti"],
    ["Vimeo", "https://vimeo.com/paulfioravanti"],
    ["Blog", "http://paulfioravanti.com/about"]
  )

  pad(10) { stroke_horizontal_rule { color "666666" } }

  text "Employment History", color: "666666", style: :bold

  position_summary(
    "Ruby Developer",
    "Freelance",
    "September 2012 – Present | Adelaide, Australia"
  )

  move_down 10
  text "Project and short-term contract work with Adelaide start-up companies "\
       "using Ruby on Rails, primarily remotely or in coworking spaces."

  position_summary(
    "Pre-sales Consultant",
    "Guidewire Software",
    "January 2009 – September 2011 | Tokyo, Japan"
  )

  move_down 10
  text "Complex sales of Guidewire ClaimCenter insurance claim handling "\
       "system to business and IT departments of Property & Casualty "\
       "insurance companies.  Responsibilities included:"

  bullet_list(
    "Perform value-based and technology-focused presentations and product "\
    "demonstrations",
    "Conduct Agile-driven Proof of Concept workshops for prospects",
    "Work with System Integrator partner companies in their Guidewire project "\
    "proposals",
    "Conduct business process and product value consulting workshops for "\
    "prospects/customers",
    "Prepare written responses to customer RFP/RFIs",
    "Demo environment configuration and prospect requirement-driven function "\
    "development",
    "Product localization development for Japanese market",
    "Customer product training",
    "Japan and overseas trade shows/marketing events"
  )

  position_summary(
    "Implementation Consultant, Professional Services",
    "Right Now Technologies",
    "July 2007 – August 2008 | Tokyo, Japan"
  )

  move_down 10
  text "On and off-site customer implementations of Right Now Cloud CRM "\
       "product.  Responsibilities included:"

  bullet_list(
    "Confirm high-level business requirements feasibility with pre-sales team",
    "Documentation: project charter, scope, schedules, and technical design "\
    "of customizations",
    "Conduct inception phase requirements workshops for business processes, "\
    "workflows, and product implementation; determine possible out-of-scope "\
    "change requests as needed",
    "Configure and setup product test environment for client to track project "\
    "progress",
    "Manage, QA, and localize customization work performed by engineers",
    "Document and execute on-site UAT and training",
    "Prepare and execute “site go-live”, analyze risks, prepare fallback plans",
    "Work with customer support to handle implementation-related support "\
    "incidents",
    "Host, linguistically support, and handle Japan immigration of overseas "\
    "project members"
  )

  position_summary(
    "Software Engineer",
    "Software Research Associates (SRA)",
    "April 2006 – June 2007 | Tokyo, Japan"
  )

  move_down 10
  text "Custom software development in small teams; design, coding, testing, "\
       "documentation, deployment; internal system administration duties.  "\
       "Development predominantly done using Pure Ruby/Ruby on Rails in small "\
       "teams of 2-3 people."

  position_summary(
    "Coordinator of International Relations (CIR)",
    "Japan Exchange and Teaching Programme (JET)",
    "July 2001 – July 2004 | Kochi, Japan"
  )

  move_down 10
  text "Translation; interpreting; editorial supervision of bilingual "\
       "pamphlets; reception of foreign guests; planning and implementing "\
       "international exchange projects; accompanying tour groups overseas; "\
       "work with non-profit organizations"

  position_summary(
    "International Marketing Assistant – Asia and Japan",
    "South Australian Tourism Commission",
    "May 2000 – May 2001 | Adelaide, Australia"
  )

  move_down 10
  text "Process trade enquiries from Asia and Japan; assist operators of "\
       "tourism products in South Australia with Japan/Asia marketing; "\
       "assisting with trade shows, the sourcing of suitable promotional "\
       "items for campaigns, and marketing research"

  move_down 10
  stroke_horizontal_rule { color "666666" }

  move_down 10
  text "Education", color: "666666", style: :bold

  position_summary(
    "Masters of Information Technology",
    "University of South Australia",
    "2004-2005 | Adelaide, Australia"
  )

  position_summary(
    "Bachelor of International Business",
    "Flinders University",
    "1997-1999 | Adelaide, Australia"
  )

  position_summary(
    "Student Exchange Programme",
    "Ryukoku University",
    "Sep 1999 - Feb 2000 | Kyoto, Japan"
  )

  position_summary(
    "Certificate II in Tourism",
    "Adelaide TAFE",
    "May 2000 - May 2001 | Adelaide, Australia"
  )
end

################################################################################
### Post-document generation handling
################################################################################
puts green "Resume generated successfully."
print yellow "Would you like me to open the resume for you (Y/N)? "
response = gets.chomp
open_document if yes?(response)
puts cyan "Thanks for generating my resume.  Hope to hear from you soon!"