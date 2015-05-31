module Resume
  module PDF
    class Options
      include Decoder

      def self.for(resume)
        author = d(resume[:author])
        {
          margin_top: resume[:margin_top],
          margin_bottom: resume[:margin_bottom],
          margin_left: resume[:margin_left],
          margin_right: resume[:margin_right],
          background: open(resume[:background_image]),
          repeat: resume[:repeat],
          info: {
            Title: d(resume[:document_name]),
            Author: author,
            Creator: author,
            CreationDate: Time.now
          }
        }
      end
    end
  end
end
