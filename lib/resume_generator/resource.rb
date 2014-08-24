module ResumeGenerator
  class Resource
    extend Decodable

    attr_reader :image, :link, :width, :height, :fit, :align,
                :move_up, :bars, :size, :origin, :at

    def self.for(params)
      params[:image] = open(params[:image])
      params[:link] = d(params[:link])
      params[:align] = params[:align].to_sym
      new(params)
    end

    private

    def initialize(params)
      params.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end
