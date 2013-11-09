require 'decodable'

module ResumeGenerator
  class Link
    extend Decodable

    LINK_BANK = {
      email:
        'bWFpbHRvOnBhdWwuZmlvcmF2YW50aUBnbWFpbC5jb20=',
      linked_in:
        'aHR0cDovL2xpbmtlZGluLmNvbS9pbi9wYXVsZmlvcmF2YW50aQ==',
      github:
        'aHR0cDovL2dpdGh1Yi5jb20vcGF1bGZpb3JhdmFudGk=',
      stackoverflow:
        "aHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3VzZXJzLzU2Nzg2My9wYXVsLWZpb3Jh"\
          "dmFudGk=",
      speakerdeck:
        'aHR0cHM6Ly9zcGVha2VyZGVjay5jb20vcGF1bGZpb3JhdmFudGk=',
      vimeo:
        'aHR0cHM6Ly92aW1lby5jb20vcGF1bGZpb3JhdmFudGk=',
      code_school:
        'aHR0cDovL3d3dy5jb2Rlc2Nob29sLmNvbS91c2Vycy9wYXVsZmlvcmF2YW50aQ==',
      twitter:
        'aHR0cHM6Ly90d2l0dGVyLmNvbS9wZWZpb3JhdmFudGk=',
      blog:
        'aHR0cDovL3BhdWxmaW9yYXZhbnRpLmNvbS9hYm91dA==',
      rc:
        'aHR0cDovL3d3dy5yYXRlY2l0eS5jb20uYXUv',
      ruby:
        'aHR0cDovL3d3dy5ydWJ5LWxhbmcub3JnL2VuLw==',
      rails:
        'aHR0cDovL3J1YnlvbnJhaWxzLm9yZy8=',
      gw:
        'aHR0cDovL3d3dy5ndWlkZXdpcmUuY29tLw==',
      rnt:
        "aHR0cDovL3d3dy5vcmFjbGUuY29tL3VzL3Byb2R1Y3RzL2FwcGxpY2F0aW9uc"\
          "y9yaWdodG5vdy9vdmVydmlldy9pbmRleC5odG1s",
      sra:
        'aHR0cDovL3d3dy5zcmEuY28uanAvaW5kZXgtZW4uc2h0bWw=',
      jet:
        "aHR0cDovL3d3dy5qZXRwcm9ncmFtbWUub3JnL2UvYXNwaXJpbmcvcG9zaXRpb25"\
          "zLmh0bWw=",
      satc:
        'aHR0cDovL3d3dy5zb3V0aGF1c3RyYWxpYS5jb20v',
      mit:
        'aHR0cHM6Ly93d3cudW5pc2EuZWR1LmF1Lw==',
      bib:
        'aHR0cDovL3d3dy5mbGluZGVycy5lZHUuYXUv',
      ryu:
        'aHR0cDovL3d3dy5yeXVrb2t1LmFjLmpwL2VuZ2xpc2gyL2luZGV4LnBocA==',
      tafe:
        'aHR0cDovL3d3dy50YWZlc2EuZWR1LmF1'
    }

    def self.for(resource)
      d(LINK_BANK.fetch(:"#{resource}"))
    end
  end
end
