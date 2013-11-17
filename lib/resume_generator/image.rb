require 'open-uri'

module ResumeGenerator
  class Image
    IMAGE_BANK = {
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
