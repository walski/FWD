module FWD
  class Scene
    @object_listeners = Hash.new
    
    def self.new(*args)
      obj = self.allocate
      obj.__send__ :initialize, *args
      obj.__send__ :__obj_init
      obj
    end
    
    def initialize
      @z_level_repository = Array.new
      def @z_level_repository.z_level_each
        self.each do |z_level|
          if z_level
            z_level.each do |obj|
              yield obj
            end
          end
        end
      end
      
      @objects = Hash.new
    end
    
    def find(clazz, &blck)
      return nil unless @objects[clazz]
      results = Array.new

      @objects[clazz].each do |obj|
        results << obj if !blck || blck.call(obj)
      end

      results
    end
    
    def spawn(obj, z)
      @z_level_repository[z] ||= Array.new
      @z_level_repository[z] <<  obj
      
      @objects[obj.class]    ||= Array.new
      @objects[obj.class]    << obj

      return unless self.class.object_listeners && 
          self.class.object_listeners[obj.class]
          
      each_listener(obj) do |listener, attribute, claim_name|
        listener.add_listening_object(obj, attribute, claim_name)
      end
    end
    
    def remove(obj)
      @z_level_repository.each {|z_level| z_level.delete(obj) if z_level}
      
      @objects[obj.class].delete(obj)
      
      each_listener(obj) do |listener, attribute, claim_name|
        listener.remove_listening_object(obj, attribute, claim_name)
      end
    end
    
    def draw
      @z_level_repository.z_level_each do |obj|
        obj.draw if obj.respond_to? :draw
      end
    end
    
    def update
      @z_level_repository.z_level_each do |obj|
        obj.__internal_update if obj.respond_to? :__internal_update
      end
    end
    
    def include?(obj)
      @objects[obj.class] && @objects[obj.class].include?(obj)
    end
    
    def self.register_objects_listener(name, clazz, attribute, 
                                       listener_class, type)
        
      @object_listeners[clazz]            ||= Array.new
      @object_listeners[clazz] << {:attribute => attribute, 
                                   :claim_name => name,
                                   :listener_class => listener_class}
                                   
      listener_class.class_eval <<-eos
        def #{name}
          return [] unless @__listening_objects[#{clazz}] &&
                           @__listening_objects[#{clazz}][:#{attribute}] &&
                           @__listening_objects[#{clazz}][:#{attribute}][:#{name}]
                           
          @__listening_objects[#{clazz}][:#{attribute}][:#{name}].select do |o|
            __listen_check_for_#{name}(o)
          end
        end
      eos
      case type
        when :common_attribute
          listener_class.class_eval <<-eos
            def __listen_check_for_#{name}(other)
              #{attribute} == other.#{attribute}
            end
          eos
        when :foreign_key
          listener_class.class_eval <<-eos
            def __listen_check_for_#{name}(other)
              self == other.#{attribute}
            end
          eos
        else
          raise ArgumentError.new("Not possible to register an object " + 
                                  "listener of that type!", type)
      end
    end
    
    private
    def __obj_init
      Repository.register_scene(self)
    end
    
    def self.object_listeners
      @object_listeners
    end
    
    def each_listener(obj)
      listener_infos = self.class.object_listeners[obj.class] || []
      listener_infos.each do |listener_info|
        listener_class = listener_info[:listener_class]
        attribute      = listener_info[:attribute]
        claim_name     = listener_info[:claim_name]
        
        @objects[listener_class].each do |listener|
          yield listener, attribute, claim_name
        end
      end
    end
  end
end
