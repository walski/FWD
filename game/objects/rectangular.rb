class Rectangular < FWD::Object
  attr_accessor :width, :height, :color
  
  def initialize(x, y, width, height, color, centered = true)
    super(x, y)
    @width    = width
    @height   = height
    @centered = centered
    @color = color
  end
  
  def draw
    draw_rectangular(@x, @y, @width, @height, @color, @centered)
  end
  
  
  def collide?(x,y)
    own_x, own_y = center_coordinates(@x, @y, @width, @height, @centered)
    
    ((own_x <= x && own_x + width >= x) || (own_x >= x && own_x + width <= x)) &&
    ((own_y <= y && own_y + height >= y) || (own_y >= y && own_y + height <= y))
  end
  
  protected
  def draw_rectangular(x, y, width, height, color, centered)
    x, y = center_coordinates(x, y, width, height, centered)
    draw_line(x, y, color, x + width, y, color)
    draw_line(x + width, y, color, x + width, y + height, color)
    draw_line(x + width, y + height, color, x, y + height, color)
    draw_line(x, y + height, color, x, y, color)
  end
  
  def center_coordinates(x, y, width, height, centered)
    centered ? [x - width / 2, y - height / 2] : [x, y]
  end
  
end