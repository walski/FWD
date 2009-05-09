module FWD
  # This class is some kind of central repository to hold all the
  # important elements of the game. E.g. the game window object and so on.
  # Everything is static.
  class Game
    require 'window'
    
    def self.start
      @window = Window.new
      @window.show
    end
    
    def self.window
      @window
    end
    
  end
end
