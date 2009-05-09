module FWD
  module WindowDelegator
    def method_missing(method_name, *attributes)
      Game.window.send(method_name, *attributes)
    end
    
  end
end