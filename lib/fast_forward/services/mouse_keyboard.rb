module FWD
  module Service
    class MouseKeyboard < Base
      CLICK_MARGIN  = 4
      KEY_PRESS_GAP = 0.1
      
      @mouse_down   = Hash.new
      @key_down     = Hash.new
      @clicks       = Array.new
      @dragging     = Array.new
      
      def self.button_down(button)
        if mouse?(button)
          @mouse_down[button] = [mouse_x, mouse_y]
        else
          @key_down[button]   = Time.new.to_f
        end
      end
      
      def self.button_up(button)
        if mouse?(button)
          if @mouse_down[button]
            distance = mouse_press_distance(*@mouse_down[button])
            @clicks << button if distance < CLICK_MARGIN
          end
          
          if @dragging.include?(button)
            @listeners.call(:drag_end, button)
            @dragging.delete button
          end
          
          @mouse_down.delete(button)
        else
          @key_down.delete(button)
        end
      end
      
      def self.update
        current_time = Time.now.to_f
        
        @key_down.each_pair do |key, press_time|
          if press_time < current_time
            @key_down[key] += KEY_PRESS_GAP
            @listeners.call(:key_press, key)
          end 
        end
        
        @clicks.each do |button|
          @listeners.call(:click, button)
        end
        @clicks.clear
        
        @mouse_down.each_pair do |button, start_coords|
          distance = mouse_press_distance(*start_coords)
          if distance > CLICK_MARGIN
            @listeners.call(:drag_start, button, *start_coords)
            @dragging << button
            @mouse_down.delete button
          end
        end
        
      end
      
      private
      def self.mouse?(button)
        button == Gosu::Button::MsLeft || button == Gosu::Button::MsMiddle || 
        button == Gosu::Button::MsRight
      end
      
      def self.mouse_press_distance(x, y)
        return Math.sqrt((mouse_x - x) ** 2 + (mouse_y - y) ** 2)
      end
      
      def self.mouse_x
        Game.window.mouse_x
      end
      
      def self.mouse_y
        Game.window.mouse_y
      end
      
    end
  end
end