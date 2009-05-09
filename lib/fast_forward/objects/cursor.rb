module FWD
  class Cursor < FWD::Object
    def initialize(color = nil)
      @x = 0
      @y = 0
      
      @color = color || Gosu::Color.new(255,255,255)
    end
    
    def update
      @x = mouse_x
      @y = mouse_y
    end
    
    def draw
      draw_line @x, @y, @color, @x + 6, @y + 12, @color
      draw_line @x, @y, @color, @x, @y + 13, @color
    end
  end
end