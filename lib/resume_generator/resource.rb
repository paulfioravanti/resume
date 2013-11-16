module ResumeGenerator
  class Resource
    extend Decodable

    attr_reader :image, :link, :width, :height, :fit, :align, :move_up, :bars,
                :size, :origin

    def self.for(hash)
      hash[:image] = open(hash[:image])
      hash[:link] = d(hash[:link])
      hash[:align] = hash[:align].to_sym
      new(hash)
    end

    private

    def initialize(options)
      options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end
