module ResumeGenerator
  class Resource
    extend Decodable

    attr_reader :image, :link

    def self.for(hash)
      new(image: open(hash[:image]), link: d(hash[:link]))
    end

    private

    def initialize(options)
      options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end
