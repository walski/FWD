module FWD
  class Object
    require 'repository'
    require 'window_delegator'
    include WindowDelegator
    
    attr_accessor :x, :y
    
    @__collisions = Array.new
    
    def initialize(x, y)
      @x = x
      @y = y
      __obj_init
    end
    
    def self.inherited(subclass)
      subclass.class_eval do
        @__collisions = Array.new
      end
    end
    
    def self.new(*args)
      obj = self.allocate
      obj.__send__ :initialize, *args
      obj.__send__ :__obj_init
      obj
    end
    
    def destroy
      Repository.unregister(self)
      freeze
    end
    
    def add_listening_object(object, attribute, claim_name)
      @__listening_objects[object.class]                        ||= Hash.new
      @__listening_objects[object.class][attribute]             ||= Hash.new
      @__listening_objects[object.class][attribute][claim_name] ||= Array.new
      @__listening_objects[object.class][attribute][claim_name] << object
    end
        
    def remove_listening_object(object, attribute, claim_name)
      return unless @__listening_objects[object.class] && 
                    @__listening_objects[object.class][attribute] &&
                    @__listening_objects[object.class][attribute][claim_name]
                    
      @__listening_objects[object.class][attribute][claim_name].delete(object)
    end

    def __internal_update
      self.class.__collisions.each do |collision|
        colliding_objects = FWD::Controller.scene.find(collision[:class]) {
                              |o| collide?(o.x, o.y) || o.collide?(x, y)}
                              
        colliding_objects.each do |colliding_object|
          collision[:filter].call(self, colliding_object)
        end
      end
      update if respond_to?(:update) && !frozen?
    end
    
    private
    def __obj_init
      register_at_repository
      @__listening_objects = Hash.new
    end
    
    def register_at_repository
      Repository.register(self)
    end
    
    def self.claims(name, clazz)
      result = {:name => name, :class => clazz, :listener_class => self}
      def result.with_same(attribute)
        FWD::Scene.register_objects_listener(
            self[:name], self[:class], attribute, self[:listener_class], 
            :common_attribute)
      end
      
      def result.identified_by(foreign_key)
        FWD::Scene.register_objects_listener(
            self[:name], self[:class], foreign_key, self[:listener_class], 
            :foreign_key)
      end
      
      result
    end
    
    def self.on_collision_with(clazz, &blck)
      @__collisions << {:class => clazz, :filter => blck}
    end
    
    def self.__collisions
      @__collisions
    end
    
  end
end
