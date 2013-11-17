require 'decodable'

module ResumeGenerator
  class Link
    extend Decodable

    LINK_BANK = {
      ryu:
        'aHR0cDovL3d3dy5yeXVrb2t1LmFjLmpwL2VuZ2xpc2gyL2luZGV4LnBocA==',
      ryu_location:
        "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
          "SZobD1lbiZnZW9jb2RlPSZxPSVFNCVCQSVBQyVFOSU4MyVCRCVFNSVCQSU5Qy"\
          "VFNCVCQSVBQyVFOSU4MyVCRCVFNSVCOCU4MiVFNCVCQyU4RiVFOCVBNiU4QiV"\
          "FNSU4QyVCQSVFNiVCNyVCMSVFOCU4RCU4OSVFNSVBMSU5QSVFNiU5QyVBQyVF"\
          "NyU5NCVCQSVFRiVCQyU5NiVFRiVCQyU5NyZhcT0mc2xsPS0zNS4wMTY3ODIsM"\
          "TM4LjU2Nzk4MiZzc3BuPTAuMDU2Nzk4LDAuMDcxNTgzJnZwc3JjPTYmZz1TdH"\
          "VydCtSZCwrQmVkZm9yZCtQYXJrK1NvdXRoK0F1c3RyYWxpYSs1MDQyJmllPVV"\
          "URjgmaHE9JmhuZWFyPUphcGFuLCtLeSVDNSU4RHRvLWZ1LCtLeSVDNSU4RHRv"\
          "LXNoaSwrRnVzaGltaS1rdSwrRnVrYWt1c2ErVHN1a2Ftb3RvY2glQzUlOEQsK"\
          "yVFRiVCQyU5NiVFRiVCQyU5NyZsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNwbj"\
          "0wLjAwNzEwNCwwLjAwODk0OCZ0PW0mej0xNyZpd2xvYz1B",
      tafe:
        'aHR0cDovL3d3dy50YWZlc2EuZWR1LmF1',
      tafe_location:
        "aHR0cHM6Ly9tYXBzLmdvb2dsZS5jb20uYXUvbWFwcz9mPXEmc291cmNlPXNfc"\
          "SZobD1lbiZnZW9jb2RlPSZxPTEyMCtDdXJyaWUrU3RyZWV0K0FERUxBSURFK1"\
          "NBKzUwMDAmYXE9JnNsbD0zNC45NjM5NzQsMTM1Ljc2Nzk3JnNzcG49MC4wMDc"\
          "xMDQsMC4wMDg5NDgmdnBzcmM9NiZpZT1VVEY4JmhxPSZobmVhcj0xMjArQ3Vy"\
          "cmllK1N0LCtBZGVsYWlkZStTb3V0aCtBdXN0cmFsaWErNTAwMCZ0PW0mbGw9L"\
          "TM0LjkyNDU0LDEzOC41OTU1MTImc3BuPTAuMDE0MjE1LDAuMDE3ODk2Jno9MT"\
          "YmaXdsb2M9QQ=="
    }

    def self.for(resource)
      d(LINK_BANK.fetch(:"#{resource}"))
    end
  end
end
