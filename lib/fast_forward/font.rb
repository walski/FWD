module FWD
  class Font < Gosu::Font
    def initialize(font, size)
      super(Game.window, font, size)
    end
  end
end
    