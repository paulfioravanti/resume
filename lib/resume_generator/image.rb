require 'open-uri'

module ResumeGenerator
  class Image
    IMAGE_BANK = {
      background:
        'http://farm6.staticflickr.com/5453/8801916021_3ac1df6072_o_d.jpg',
      email:
        'http://farm3.staticflickr.com/2826/8753727736_2a7a294527_m.jpg',
      linked_in:
        'http://farm4.staticflickr.com/3687/8809717292_4938937a94_m.jpg',
      github:
        'http://farm4.staticflickr.com/3828/8799239149_d23e4acff0_m.jpg',
      stackoverflow:
        'http://farm3.staticflickr.com/2815/8799253647_e4ec3ab1bc_m.jpg',
      speakerdeck:
        'http://farm8.staticflickr.com/7404/8799250189_4125b90a14_m.jpg',
      vimeo:
        'http://farm9.staticflickr.com/8546/8809862216_0cdd40c3dc_m.jpg',
      code_school:
        'http://farm4.staticflickr.com/3714/9015339024_0651daf2c4_m.jpg',
      twitter:
        'http://farm3.staticflickr.com/2837/8799235993_26a7d17540_m.jpg',
      blog:
        'http://farm4.staticflickr.com/3752/8809826162_e4d765d15b_m.jpg',
      rc:
        'http://farm6.staticflickr.com/5484/9192095974_b49a1fc142_m.jpg',
      ruby:
        'http://farm4.staticflickr.com/3793/8799953079_33cfdc0def_m.jpg',
      rails:
        'http://farm4.staticflickr.com/3681/8810534562_dfc34ea70c_m.jpg',
      gw:
        'http://farm8.staticflickr.com/7376/8812488914_f0bfd0a841_m.jpg',
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
