module FWD
  module Service
    class Base
      def self.inherited(subclass)
        subclass.class_eval do
          __init_listeners
        end
      end
      
      def self.register(listener)
        @listeners << listener.class unless @listeners.include? listener.class
        @listeners << listener
      end
      
      private
      def self.__init_listeners
        @listeners = Array.new
        def @listeners.call(method, *args)
          self.each do |listener|
            if (listener.class == Class || 
                FWD::Controller.scene.include?(listener)) &&
                listener.respond_to?(method)

              listener.send(method, *args)
            end
          end
        end
      end
      
      __init_listeners
    end
  end
end