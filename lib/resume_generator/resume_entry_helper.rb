module ResumeGenerator
  module ResumeEntryHelper
    def employment_history
      heading d('RW1wbG95bWVudCBIaXN0b3J5')
      rc
      fl
      gw
      rnt
      sra
      jet
      satc
      move_down 10
      stroke_horizontal_rule { color '666666' }
    end

    def education_history
      heading d('RWR1Y2F0aW9u')
      mit
      bib
      ryu
      tafe
    end

    def rc
      header_text_for(:rc, 10)
      organisation_logo_for(:rc)
      content_for(:rc)
    end

    def fl
      header_text_for(:fl)
      organisation_logo_for(:fl, :ruby)
      organisation_logo_for(:fl, :rails, 33)
      content_for(:fl, 15)
    end

    def gw
      header_text_for(:gw)
      organisation_logo_for(:gw)
      content_for(:gw)
    end

    def rnt
      header_text_for(:rnt)
      organisation_logo_for(:rnt)
      content_for(:rnt)
    end

    def sra
      header_text_for(:sra)
      organisation_logo_for(:sra)
      content_for(:sra)
    end

    def jet
      header_text_for(:jet)
      organisation_logo_for(:jet)
      content_for(:jet)
    end

    def satc
      header_text_for(:satc)
      organisation_logo_for(:satc)
      content_for(:satc)
    end

    def mit
      header_text_for(:mit)
      organisation_logo_for(:mit)
    end

    def bib
      move_up 38
      header_text_for(:bib, 0)
      move_up 30
      organisation_logo_for(:bib, :bib, 0)
    end

    def ryu
      header_text_for(:ryu, 20)
      organisation_logo_for(:ryu)
    end

    def tafe
      move_up 38
      header_text_for(:tafe, 0)
      move_up 23
      organisation_logo_for(:tafe, :tafe, 0)
    end
  end
end