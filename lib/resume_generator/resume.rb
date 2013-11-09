require 'resume_helper'
require 'decodable'

module ResumeGenerator
  class Resume

    def self.generate
      Prawn::Document.class_eval do
        include ResumeHelper, Decodable
      end
      Prawn::Document.generate("#{DOCUMENT_NAME}.pdf",
        margin_top: 0.75, margin_bottom: 0.75, margin_left: 1, margin_right: 1,
        background: Image.for('background'),
        repeat: true) do

        CLI.report "Generating PDF. "\
                   "This shouldn't take longer than a few seconds..."
        header
        CLI.report 'Creating social media links section...'
        social_media_links
        CLI.report 'Creating employment history section...'
        heading 'RW1wbG95bWVudCBIaXN0b3J5'
        rc
        fl
        gw
        rnt
        sra
        jet
        satc
        CLI.report('Creating education history section...')
        heading 'RWR1Y2F0aW9u'
        mit
        bib
        ryu
        tafe
      end
    end
  end
end
