module FWD
  class Text < FWD::Object
    require 'font'
    
    attr_accessor :text, :font
    
    def initialize(x, y, text, size = nil, font = nil)
      super(x,y)
      @text = text
      
      @font = Font.new(font || Gosu::default_font_name, size || 20)
    end
    
    def draw
      @font.draw(@text, @x, @y, 1, 1.0, 1.0, 0xffffff00)
    end
  end
end