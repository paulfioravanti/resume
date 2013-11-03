require 'image'
require 'link'

module Resume
  class Resource
    attr_reader :image, :link

    def self.for(name)
      new(image: Image.for(:"#{name}"), link: Link.for(:"#{name}"))
    end

    def initialize(options)
      options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end