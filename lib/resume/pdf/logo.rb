require_relative '../file_fetcher'

module Resume
  module PDF
    class Logo
      attr_reader :image, :link, :width, :height, :fit, :align,
                  :link_overlay_start, :bars, :size, :origin, :at, :y_start

      def self.for(data)
        data[:image] = FileFetcher.fetch(data[:image])
        data[:link] = Decoder.d(data[:link])
        data[:align] = data[:align].to_sym
        new(data)
      end

      private_class_method :new

      def initialize(data)
        data.each do |attribute, value|
          instance_variable_set("@#{attribute}", value)
        end
      end
    end
  end
end
