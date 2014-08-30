module ResumeGenerator
  class Resource
    extend Decodable

    attr_reader :image, :link, :width, :height, :fit, :align,
                :move_up, :bars, :size, :origin, :at

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
