require 'image'
require 'link'

module ResumeGenerator
  class Resource
    attr_reader :image, :link

    def self.for(name)
      new(image: Image.for(:"#{name}"), link: Link.for(:"#{name}"))
    end

    private

    def initialize(options)
      options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end
