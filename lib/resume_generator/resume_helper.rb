require 'image'
require 'link'
require 'resource'

module ResumeGenerator
  module ResumeHelper
    private

    def bullet_list(*items)
      table_data = []
      items.each do |item|
        table_data << ['•', d(item)]
      end
      table(table_data, cell_style: { borders: [] })
    end

    def social_media_links
      resources = social_media_resources
      x_position = 0
      bounding_box_for(resources.first, x_position)
      x_position += 45
      resources[1..-1].each do |image_link|
        move_up 46.25
        bounding_box_for(image_link, x_position)
        x_position += 45
      end
    end

    def bounding_box_for(image_link, x_position)
      bounding_box([x_position, cursor], width: 35) do
        image image_link.image, fit: [35, 35], align: :center
        move_up 35
        transparent(0) do
          formatted_text([{
            text: '|||',
            size: 40,
            link: image_link.link
          }], align: :center)
        end
      end
    end

    def social_media_resources
      %w(email linked_in github stackoverflow
         speakerdeck vimeo code_school blog).map do |item|
        Resource.for(item)
      end
    end

    def heading(string)
      formatted_text([{ text: d(string), styles: [:bold], color: '666666' }])
    end

    def name(string)
      font('Times-Roman', size: 20) { text d(string) }
    end

    def description(ruby, rest)
      formatted_text(
        [
          { text: d(ruby), color: '85200C' },
          { text: d(rest) }
        ],
        size: 14
      )
    end

    def position(title, options = {})
      if options.has_key?(:at)
        formatted_text_box(
          [{ text: d(title), styles: [:bold] }], at: [options[:at], cursor]
        )
      else
        formatted_text([{ text: d(title), styles: [:bold] }])
      end
    end

    def organisation(name, options = {})
      if options.has_key?(:at)
        formatted_text_box(
          [{ text: d(name), styles: [:bold], size: 11 }],
          at: [options[:at], cursor]
        )
      else
        formatted_text([{ text: d(name), styles: [:bold], size: 11 }])
      end
    end

    def period_and_location(options)
      if options.has_key?(:at)
        formatted_text_box(
          [
            { text: d(options[:period]), color: '666666', size: 10 },
            {
              text: d(options[:location]),
              link: d(options[:link]),
              color: '666666', size: 10
            }
          ],
          at: [options[:at], cursor]
        )
      else
        formatted_text([
          { text: d(options[:period]) },
          {
            text: d(options[:location]),
            link: d(options[:link])
          }
        ], color: '666666', size: 10)
      end
    end

    def organisation_logo(options)
      bounding_box([options[:origin], cursor],
                   width: options[:width],
                   height: options[:height]) do
        image Image.for(options[:organisation]),
              fit: options[:fit],
              align: :center
        move_up options[:move_up]
        transparent(0) do
          formatted_text([{
            text: '|' * options[:bars],
            size: options[:size],
            link: Link.for(options[:organisation])
          }])
        end
      end
    end
  end
end
