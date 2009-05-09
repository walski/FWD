module FWD
  class Window < Gosu::Window
    def initialize
      params = Config.resolution + [false]
      super(*params)
      self.caption = Config.caption if Config.caption
    end

    def update
      FWD::Service::MouseKeyboard.update
      Controller.update
    end

    def draw
      Controller.draw
    end
    
    def button_down(id)
      FWD::Service::MouseKeyboard.button_down(id)
    end
    
    def button_up(id)
      FWD::Service::MouseKeyboard.button_up(id)
    end
  end
end