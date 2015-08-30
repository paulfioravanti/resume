require_relative '../file_fetcher'

module Resume
  module PDF
    class Options
      def self.generate(title, resume)
        author = Decoder.d(resume[:author])
        {
          margin_top: resume[:margin_top],
          margin_bottom: resume[:margin_bottom],
          margin_left: resume[:margin_left],
          margin_right: resume[:margin_right],
          background: FileFetcher.fetch(resume[:background_image]),
          repeat: resume[:repeat],
          info: {
            Title: title,
            Author: author,
            Creator: author,
            CreationDate: Time.now
          }
        }
      end
    end
  end
end
