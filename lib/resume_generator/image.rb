require 'open-uri'

module ResumeGenerator
  class Image
    IMAGE_BANK = {
      gw:
        '',
      rnt:
        'http://farm8.staticflickr.com/7326/8801904137_e6008ee907_m.jpg',
      sra:
        'http://farm4.staticflickr.com/3801/8801903945_723a5d7276_m.jpg',
      jet:
        'http://farm4.staticflickr.com/3690/8801904135_37197a468c_m.jpg',
      satc:
        'http://farm4.staticflickr.com/3804/8801903991_103f5a47f8_m.jpg',
      mit:
        'http://farm4.staticflickr.com/3792/8812488692_96818be468_m.jpg',
      bib:
        'http://farm4.staticflickr.com/3707/8812488974_71c6981155_m.jpg',
      ryu:
        'http://farm8.staticflickr.com/7428/8812488856_c4c1b1f418_m.jpg',
      tafe:
        'http://farm8.staticflickr.com/7377/8812488734_e43ce6742b_m.jpg'
    }

    def self.for(resource)
      open(IMAGE_BANK.fetch(:"#{resource}"))
    end
  end
end
