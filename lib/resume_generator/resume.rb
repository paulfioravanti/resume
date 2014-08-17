require 'resume_helper'

module ResumeGenerator
  class Resume
    def self.generate
      Prawn::Document.class_eval do
        include ResumeHelper
      end
      Prawn::Document.generate("#{DOCUMENT_NAME}.pdf", pdf_options) do
        name
        headline
        social_media_icons
        employment_history
        education_history
      end
    end

    def self.pdf_options
      {
        margin_top: 0.75,
        margin_bottom: 0.75,
        margin_left: 1,
        margin_right: 1,
        background: background_image,
        repeat: true
      }
    end
    private_class_method :pdf_options
  end
end
