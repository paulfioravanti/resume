module ResumeGenerator
  module Resume
    class ImageLink
      extend Decoder

      attr_reader :image, :link, :width, :height, :fit, :align,
                  :link_overlay_start, :bars, :size, :origin, :at, :y_start

      def self.for(data)
        data[:image] = open(data[:image])
        data[:link] = d(data[:link])
        data[:align] = data[:align].to_sym
        new(data)
      end

      private

      def initialize(data)
        data.each do |attribute, value|
          instance_variable_set("@#{attribute}", value)
        end
      end
    end
  end
end

