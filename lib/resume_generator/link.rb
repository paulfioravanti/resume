require 'decodable'

module ResumeGenerator
  class Link
    extend Decodable

    def self.for(resource)
      d(send(:"#{resource}"))
    end

    def self.email
      'bWFpbHRvOnBhdWwuZmlvcmF2YW50aUBnbWFpbC5jb20='
    end
    private_class_method :email

    def self.linked_in
      'aHR0cDovL2xpbmtlZGluLmNvbS9pbi9wYXVsZmlvcmF2YW50aQ=='
    end
    private_class_method :linked_in

    def self.github
      'aHR0cDovL2dpdGh1Yi5jb20vcGF1bGZpb3JhdmFudGk='
    end
    private_class_method :github

    def self.stackoverflow
      "aHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3VzZXJzLzU2Nzg2My9wYXVsLWZpb3Jh"\
        "dmFudGk="
    end
    private_class_method :stackoverflow

    def self.speakerdeck
      'aHR0cHM6Ly9zcGVha2VyZGVjay5jb20vcGF1bGZpb3JhdmFudGk='
    end
    private_class_method :speakerdeck

    def self.vimeo
      'aHR0cHM6Ly92aW1lby5jb20vcGF1bGZpb3JhdmFudGk='
    end
    private_class_method :vimeo

    def self.code_school
      'aHR0cDovL3d3dy5jb2Rlc2Nob29sLmNvbS91c2Vycy9wYXVsZmlvcmF2YW50aQ=='
    end
    private_class_method :code_school

    def self.twitter
      'aHR0cHM6Ly90d2l0dGVyLmNvbS9wZWZpb3JhdmFudGk='
    end
    private_class_method :twitter

    def self.blog
      'aHR0cDovL3BhdWxmaW9yYXZhbnRpLmNvbS9hYm91dA=='
    end
    private_class_method :blog

    def self.rc
      'aHR0cDovL3d3dy5yYXRlY2l0eS5jb20uYXUv'
    end
    private_class_method :rc

    def self.ruby
      'aHR0cDovL3d3dy5ydWJ5LWxhbmcub3JnL2VuLw=='
    end
    private_class_method :ruby

    def self.rails
      'aHR0cDovL3J1YnlvbnJhaWxzLm9yZy8='
    end
    private_class_method :rails

    def self.gw
      'aHR0cDovL3d3dy5ndWlkZXdpcmUuY29tLw=='
    end
    private_class_method :gw

    def self.rnt
      "aHR0cDovL3d3dy5vcmFjbGUuY29tL3VzL3Byb2R1Y3RzL2FwcGxpY2F0aW9uc"\
        "y9yaWdodG5vdy9vdmVydmlldy9pbmRleC5odG1s"
    end
    private_class_method :rnt

    def self.sra
      'aHR0cDovL3d3dy5zcmEuY28uanAvaW5kZXgtZW4uc2h0bWw='
    end
    private_class_method :sra

    def self.jet
      "aHR0cDovL3d3dy5qZXRwcm9ncmFtbWUub3JnL2UvYXNwaXJpbmcvcG9zaXRpb25"\
        "zLmh0bWw="
    end
    private_class_method :jet

    def self.satc
      'aHR0cDovL3d3dy5zb3V0aGF1c3RyYWxpYS5jb20v'
    end
    private_class_method :satc

    def self.mit
      'aHR0cHM6Ly93d3cudW5pc2EuZWR1LmF1Lw=='
    end
    private_class_method :mit

    def self.bib
      'aHR0cDovL3d3dy5mbGluZGVycy5lZHUuYXUv'
    end
    private_class_method :bib

    def self.ryu
      'aHR0cDovL3d3dy5yeXVrb2t1LmFjLmpwL2VuZ2xpc2gyL2luZGV4LnBocA=='
    end
    private_class_method :ryu

    def self.tafe
      'aHR0cDovL3d3dy50YWZlc2EuZWR1LmF1'
    end
    private_class_method :tafe
  end
end
