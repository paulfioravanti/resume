module ResumeGenerator
  class Logo
    attr_reader :organisation, :origin, :width, :height, :fit, :move_up,
      :bars, :size

    def initialize(options)
      # options.each do |attribute, value|
      #   instance_variable_set("@#{attribute}", value)
      # end
      @organisation = options[:organisation]
      @origin = options[:origin]
      @width = options[:width]
      @height = options[:height]
      @fit = options[:fit]
      @move_up = options[:move_up]
      @bars = options[:bars]
      @size = options[:size]
    end
  end
end