DOCUMENT_NAME = "Resume"

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

def d(string) # decode string
  Base64.strict_decode64(string)
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
    { text: d(qualification) + "\n", styles: [:bold] },
    { text: d(organization) + "\n", styles: [:bold], size: 11 },
    { text: d(period), size: 10, color: "666666" }
  ])
end

def bullet_list(*items)
  table_data = []
  items.each do |item|
    table_data << ["•", d(item)]
  end
  table(table_data, cell_style: { border_color: "FFFFFF" })
end

def list_of_links(*items)
  list = []
  items.each do |text, link|
    list <<
      { text: d(text), link: d(link), styles: [:underline], color: "0000FF" }
    list << { text: "  " }
  end
  formatted_text(list)
end

def heading(string)
  formatted_text([{ text: d(string), styles: [:bold], color: "666666" }])
end

def name(string)
  font("Times-Roman", size: 20) { text d(string) }
end

def description(ruby, rest)
  formatted_text([
    { text: d(ruby), color: "85200C" },
    { text: d(rest) }
  ], size: 14)
end

################################################################################
### Get dependent gems if not available
################################################################################
unless gem_available?("prawn")
  print yellow "May I please install the 'Prawn' Ruby gem to help me generate "\
               "a PDF (Y/N)? "
  if yes?(gets.chomp)
    puts green "Thank you kindly."
    puts "Installing prawn gem..."
    begin
      %x(gem install prawn)
    rescue
      puts red "Sorry, for some reason I wasn't able to install prawn.\n"\
              "Either try again or ask me directly for a PDF copy of my resume."
      exit
    end
    puts green "Prawn gem successfully installed."
    Gem.clear_paths # Reset the dir and path values so Prawn can be required
  else
    puts red "Sorry, I won't be able to generate a PDF without this gem.\n"\
             "Please ask me directly for a PDF copy of my resume."
    exit
  end
end

################################################################################
### Generate document
################################################################################
require "base64"
require "prawn"

Prawn::Document.generate("#{DOCUMENT_NAME}.pdf",
  margin_top: 0.75, margin_bottom: 0.75, margin_left: 1, margin_right: 1) do

  name "UGF1bCBGaW9yYXZhbnRp"
  description "UnVieSBEZXZlbG9wZXIg",
              "YW5kIEluZm9ybWF0aW9uIFRlY2hub2xvZ3kgU2VydmljZXMgUHJvZmVzc2lvbmFs"

  move_down 5
  list_of_links(
    ["RW1haWw=", "bWFpbHRvOnBhdWwuZmlvcmF2YW50aUBnbWFpbC5jb20="],
    ["TGlua2VkSW4=", "aHR0cDovL2xpbmtlZGluLmNvbS9pbi9wYXVsZmlvcmF2YW50aQ=="],
    ["R2l0aHVi", "aHR0cDovL2dpdGh1Yi5jb20vcGF1bGZpb3JhdmFudGk="],
    ["U3RhY2tPdmVyZmxvdw==", "aHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3V"\
     "zZXJzLzU2Nzg2My9wYXVsLWZpb3JhdmFudGk="],
    ["VHdpdHRlcg==", "aHR0cHM6Ly90d2l0dGVyLmNvbS9wZWZpb3JhdmFudGk="],
    ["U3BlYWtlckRlY2s=", "aHR0cHM6Ly9zcGVha2VyZGVjay5jb20vcGF1bGZ"\
     "pb3JhdmFudGk="],
    ["VmltZW8=", "aHR0cHM6Ly92aW1lby5jb20vcGF1bGZpb3JhdmFudGk="],
    ["QmxvZw==", "aHR0cDovL3BhdWxmaW9yYXZhbnRpLmNvbS9hYm91dA=="]
  )

  pad(10) { stroke_horizontal_rule { color "666666" } }

  heading "RW1wbG95bWVudCBIaXN0b3J5"

  position_summary(
    "UnVieSBEZXZlbG9wZXI=",
    "RnJlZWxhbmNl",
    "U2VwdGVtYmVyIDIwMTIg4oCTIFByZXNlbnQgfCBBZGVsYWlkZSwgQXVzdHJhbGlh"
  )

  move_down 10
  text d "UHJvamVjdCBhbmQgc2hvcnQtdGVybSBjb250cmFjdCB3b3JrIHdpdGggQWRlbGFp"\
         "ZGUgc3RhcnQtdXAgY29tcGFuaWVzIHVzaW5nIFJ1Ynkgb24gUmFpbHMsIHByaW1h"\
         "cmlseSByZW1vdGVseSBvciBpbiBjb3dvcmtpbmcgc3BhY2VzLg=="

  position_summary(
    "UHJlLXNhbGVzIENvbnN1bHRhbnQ=",
    "R3VpZGV3aXJlIFNvZnR3YXJl",
    "SmFudWFyeSAyMDA5IOKAkyBTZXB0ZW1iZXIgMjAxMSB8IFRva3lvLCBKYXBhbg=="
  )

  move_down 10
  text d "Q29tcGxleCBzYWxlcyBvZiBHdWlkZXdpcmUgQ2xhaW1DZW50ZXIgaW5zdXJhbmNlI"\
         "GNsYWltIGhhbmRsaW5nIHN5c3RlbSB0byBidXNpbmVzcyBhbmQgSVQgZGVwYXJ0bW"\
         "VudHMgb2YgUHJvcGVydHkgJiBDYXN1YWx0eSBpbnN1cmFuY2UgY29tcGFuaWVzLiA"\
         "gUmVzcG9uc2liaWxpdGllcyBpbmNsdWRlZDo="

  bullet_list(
    "UGVyZm9ybSB2YWx1ZS1iYXNlZCBhbmQgdGVjaG5vbG9neS1mb2N1c2VkIHByZXNlbnRhdGl"\
      "vbnMgYW5kIHByb2R1Y3QgZGVtb25zdHJhdGlvbnM=",
    "Q29uZHVjdCBBZ2lsZS1kcml2ZW4gUHJvb2Ygb2YgQ29uY2VwdCB3b3Jrc2hvcHMgZm9yIHB"\
      "yb3NwZWN0cw==",
    "V29yayB3aXRoIFN5c3RlbSBJbnRlZ3JhdG9yIHBhcnRuZXIgY29tcGFuaWVzIGluIHRoZWl"\
      "yIEd1aWRld2lyZSBwcm9qZWN0IHByb3Bvc2Fscw==",
    "Q29uZHVjdCBidXNpbmVzcyBwcm9jZXNzIGFuZCBwcm9kdWN0IHZhbHVlIGNvbnN1bHRpbmc"\
      "gd29ya3Nob3BzIGZvciBwcm9zcGVjdHMvY3VzdG9tZXJz",
    "UHJlcGFyZSB3cml0dGVuIHJlc3BvbnNlcyB0byBjdXN0b21lciBSRlAvUkZJcw==",
    "RGVtbyBlbnZpcm9ubWVudCBjb25maWd1cmF0aW9uIGFuZCBwcm9zcGVjdCByZXF1aXJlbWV"\
      "udC1kcml2ZW4gZnVuY3Rpb24gZGV2ZWxvcG1lbnQ=",
    "UHJvZHVjdCBsb2NhbGl6YXRpb24gZGV2ZWxvcG1lbnQgZm9yIEphcGFuZXNlIG1hcmtldA==",
    "Q3VzdG9tZXIgcHJvZHVjdCB0cmFpbmluZw==",
    "SmFwYW4gYW5kIG92ZXJzZWFzIHRyYWRlIHNob3dzL21hcmtldGluZyBldmVudHM="
  )

  position_summary(
    "SW1wbGVtZW50YXRpb24gQ29uc3VsdGFudCwgUHJvZmVzc2lvbmFsIFNlcnZpY2Vz",
    "UmlnaHQgTm93IFRlY2hub2xvZ2llcw==",
    "SnVseSAyMDA3IOKAkyBBdWd1c3QgMjAwOCB8IFRva3lvLCBKYXBhbg=="
  )

  move_down 10
  text d "T24gYW5kIG9mZi1zaXRlIGN1c3RvbWVyIGltcGxlbWVudGF0aW9ucyBvZiBSaWdodCBO"\
         "b3cgQ2xvdWQgQ1JNIHByb2R1Y3QuICBSZXNwb25zaWJpbGl0aWVzIGluY2x1ZGVkOg=="

  bullet_list(
    "Q29uZmlybSBoaWdoLWxldmVsIGJ1c2luZXNzIHJlcXVpcmVtZW50cyBmZWFzaWJpbGl0eSB3"\
      "aXRoIHByZS1zYWxlcyB0ZWFt",
    "RG9jdW1lbnRhdGlvbjogcHJvamVjdCBjaGFydGVyLCBzY29wZSwgc2NoZWR1bGVzLCBhbmQg"\
      "dGVjaG5pY2FsIGRlc2lnbiBvZiBjdXN0b21pemF0aW9ucw==",
    "Q29uZHVjdCBpbmNlcHRpb24gcGhhc2UgcmVxdWlyZW1lbnRzIHdvcmtzaG9wcyBmb3IgYnVz"\
      "aW5lc3MgcHJvY2Vzc2VzLCB3b3JrZmxvd3MsIGFuZCBwcm9kdWN0IGltcGxlbWVudGF0aW"\
      "9uOyBkZXRlcm1pbmUgcG9zc2libGUgb3V0LW9mLXNjb3BlIGNoYW5nZSByZXF1ZXN0cyBh"\
      "cyBuZWVkZWQ=",
    "Q29uZmlndXJlIGFuZCBzZXR1cCBwcm9kdWN0IHRlc3QgZW52aXJvbm1lbnQgZm9yIGNsaWVu"\
      "dCB0byB0cmFjayBwcm9qZWN0IHByb2dyZXNz",
    "TWFuYWdlLCBRQSwgYW5kIGxvY2FsaXplIGN1c3RvbWl6YXRpb24gd29yayBwZXJmb3JtZWQg"\
      "YnkgZW5naW5lZXJz",
    "RG9jdW1lbnQgYW5kIGV4ZWN1dGUgb24tc2l0ZSBVQVQgYW5kIHRyYWluaW5n",
    "UHJlcGFyZSBhbmQgZXhlY3V0ZSDigJxzaXRlIGdvLWxpdmXigJ0sIGFuYWx5emUgcmlza3Ms"\
      "IHByZXBhcmUgZmFsbGJhY2sgcGxhbnM=",
    "V29yayB3aXRoIGN1c3RvbWVyIHN1cHBvcnQgdG8gaGFuZGxlIGltcGxlbWVudGF0aW9uLXJl"\
      "bGF0ZWQgc3VwcG9ydCBpbmNpZGVudHM=",
    "SG9zdCwgbGluZ3Vpc3RpY2FsbHkgc3VwcG9ydCwgYW5kIGhhbmRsZSBKYXBhbiBpbW1pZ3Jh"\
      "dGlvbiBvZiBvdmVyc2VhcyBwcm9qZWN0IG1lbWJlcnM="
  )

  position_summary(
    "U29mdHdhcmUgRW5naW5lZXI=",
    "U29mdHdhcmUgUmVzZWFyY2ggQXNzb2NpYXRlcyAoU1JBKQ==",
    "QXByaWwgMjAwNiDigJMgSnVuZSAyMDA3IHwgVG9reW8sIEphcGFu"
  )

  move_down 10
  text d "Q3VzdG9tIHNvZnR3YXJlIGRldmVsb3BtZW50IGluIHNtYWxsIHRlYW1zOyBkZXNpZ24"\
         "sIGNvZGluZywgdGVzdGluZywgZG9jdW1lbnRhdGlvbiwgZGVwbG95bWVudDsgaW50ZX"\
         "JuYWwgc3lzdGVtIGFkbWluaXN0cmF0aW9uIGR1dGllcy4gIERldmVsb3BtZW50IHByZ"\
         "WRvbWluYW50bHkgZG9uZSB1c2luZyBQdXJlIFJ1YnkvUnVieSBvbiBSYWlscyBpbiBz"\
         "bWFsbCB0ZWFtcyBvZiAyLTMgcGVvcGxlLg=="

  position_summary(
    "Q29vcmRpbmF0b3Igb2YgSW50ZXJuYXRpb25hbCBSZWxhdGlvbnMgKENJUik=",
    "SmFwYW4gRXhjaGFuZ2UgYW5kIFRlYWNoaW5nIFByb2dyYW1tZSAoSkVUKQ==",
    "SnVseSAyMDAxIOKAkyBKdWx5IDIwMDQgfCBLb2NoaSwgSmFwYW4="
  )

  move_down 10
  text d "VHJhbnNsYXRpb247IGludGVycHJldGluZzsgZWRpdG9yaWFsIHN1cGVydmlzaW9uIG9"\
         "mIGJpbGluZ3VhbCBwYW1waGxldHM7IHJlY2VwdGlvbiBvZiBmb3JlaWduIGd1ZXN0cz"\
         "sgcGxhbm5pbmcgYW5kIGltcGxlbWVudGluZyBpbnRlcm5hdGlvbmFsIGV4Y2hhbmdlI"\
         "HByb2plY3RzOyBhY2NvbXBhbnlpbmcgdG91ciBncm91cHMgb3ZlcnNlYXM7IHdvcmsg"\
         "d2l0aCBub24tcHJvZml0IG9yZ2FuaXphdGlvbnM="

  position_summary(
    "SW50ZXJuYXRpb25hbCBNYXJrZXRpbmcgQXNzaXN0YW50IOKAkyBBc2lhIGFuZCBKYXBhbg==",
    "U291dGggQXVzdHJhbGlhbiBUb3VyaXNtIENvbW1pc3Npb24=",
    "TWF5IDIwMDAg4oCTIE1heSAyMDAxIHwgQWRlbGFpZGUsIEF1c3RyYWxpYQ=="
  )

  move_down 10
  text d "UHJvY2VzcyB0cmFkZSBlbnF1aXJpZXMgZnJvbSBBc2lhIGFuZCBKYXBhbjsgYXNzaXN"\
         "0IG9wZXJhdG9ycyBvZiB0b3VyaXNtIHByb2R1Y3RzIGluIFNvdXRoIEF1c3RyYWxpYS"\
         "B3aXRoIEphcGFuL0FzaWEgbWFya2V0aW5nOyBhc3Npc3Rpbmcgd2l0aCB0cmFkZSBza"\
         "G93cywgdGhlIHNvdXJjaW5nIG9mIHN1aXRhYmxlIHByb21vdGlvbmFsIGl0ZW1zIGZv"\
         "ciBjYW1wYWlnbnMsIGFuZCBtYXJrZXRpbmcgcmVzZWFyY2g="

  move_down 10
  stroke_horizontal_rule { color "666666" }

  move_down 10
  heading "RWR1Y2F0aW9u"

  position_summary(
    "TWFzdGVycyBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5",
    "VW5pdmVyc2l0eSBvZiBTb3V0aCBBdXN0cmFsaWE=",
    "MjAwNC0yMDA1IHwgQWRlbGFpZGUsIEF1c3RyYWxpYQ=="
  )

  position_summary(
    "QmFjaGVsb3Igb2YgSW50ZXJuYXRpb25hbCBCdXNpbmVzcw==",
    "RmxpbmRlcnMgVW5pdmVyc2l0eQ==",
    "MTk5Ny0xOTk5IHwgQWRlbGFpZGUsIEF1c3RyYWxpYQ=="
  )

  position_summary(
    "U3R1ZGVudCBFeGNoYW5nZSBQcm9ncmFtbWU=",
    "Unl1a29rdSBVbml2ZXJzaXR5",
    "U2VwIDE5OTkgLSBGZWIgMjAwMCB8IEt5b3RvLCBKYXBhbg=="
  )

  position_summary(
    "Q2VydGlmaWNhdGUgSUkgaW4gVG91cmlzbQ==",
    "QWRlbGFpZGUgVEFGRQ==",
    "TWF5IDIwMDAgLSBNYXkgMjAwMSB8IEFkZWxhaWRlLCBBdXN0cmFsaWE="
  )
end

################################################################################
### Post-document generation handling
################################################################################
puts green "Resume generated successfully."
print yellow "Would you like me to open the resume for you (Y/N)? "
open_document if yes?(gets.chomp)
puts cyan "Thanks for generating my resume.  Hope to hear from you soon!"