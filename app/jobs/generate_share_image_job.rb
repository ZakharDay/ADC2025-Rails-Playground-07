require "vips"

class GenerateShareImageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    post = Post.find(args[0].id)

    if post.share_image
      filepath = post.share_image
    else
      filename = SecureRandom.hex(8)
      filepath = "shared/#{filename}.png"
    end

    border_color = [0, 230, 255, 255]
    phrase = args[0].title

    text = {
      font: 'PT Root UI Bold',
      fontfile: (File.join(Rails.root, 'public/share_source/PT_Root_UI_Bold.ttf')),
      width: 1020,
      align: 'centre',
      dpi: 252
    }

    background = Vips::Image.new_from_file(File.join(Rails.root, 'public/share_source/bg.png'))
    logo = Vips::Image.new_from_file(File.join(Rails.root, 'public/share_source/logo.png'))

    heading = Vips::Image.text(
      phrase,
      font:     text[:font],
      width:    text[:width],
      align:    text[:align],
      dpi:      text[:dpi],
      fontfile: text[:fontfile],
      rgba:     true
    )

    heading_top = 270
    heading_padding_top = 12
    heading_y = heading_top + heading_padding_top
    
    heading_width = heading.size[0]
    heading_left = 90
    heading_padding_left = (text[:width] - heading_width) / 2

    heading_x = heading_left + heading_padding_left

    background = background.draw_rect(border_color, 0,    0,   1200, 10,  fill: true)
    background = background.draw_rect(border_color, 0,    0,   10,   630, fill: true)
    background = background.draw_rect(border_color, 1190, 0,   10,   630, fill: true)
    background = background.draw_rect(border_color, 0,    620, 1200, 10,  fill: true)

    background = background.composite(logo,    'over', x: 565,       y: 99)
    background = background.composite(heading, 'over', x: heading_x, y: heading_y)

    background.write_to_file(File.join(Rails.root, "public/#{filepath}"))
    post.update_attribute!(:share_image, filepath)
  end
end
