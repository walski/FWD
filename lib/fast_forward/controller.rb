module FWD
  class Controller
    require 'scene'
    include FWD
    require 'window_delegator'
    include WindowDelegator
    
    attr_writer :scene
    
    def spawn(obj, z = 0)
      self.class.spawn(obj, z)
    end
    
    def self.spawn(obj, z = 0)
      Controller.scene.spawn(obj, z)
    end
    
    def draw
      Controller.scene.draw
    end
    
    def update
      Controller.scene.update
    end
        
    def self.show(name)
      require "game/controllers/#{name}_controller"
      @controller_class = Kernel.const_get("#{name.capitalize}Controller")
    end
    
    def self.update
      init_controller
      @controller.update if init_controller
    end
    
    def self.draw
      @controller.draw if init_controller
    end
        
    def self.scene
      @scene
    end
    
    private
    def self.init_controller
      return false unless @controller_class
      
      return true if @controller && @controller_class == @controller.class
      @scene      = Scene.new
      @controller = @controller_class.send(:new)
    end
    
  end
end
