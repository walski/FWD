class Player < FWD::Object
  attr_accessor :color
  
  claims(:cells, Cell).with_same(:color) 
  
  def initialize(color)
    @color = color
  end
  
  def drag_start(id, x, y)
    if id == Gosu::Button::MsLeft
      @current_drag = Selection.new(x, y, 0, 0, Gosu::Color.new(255,255,0))
      FWD::Controller.spawn(@current_drag)
    end
  end
  
  def drag_end(id)
    if id == Gosu::Button::MsLeft
      Cell.unselect_all!(color)
      (cells & @current_drag.chosen_cells).each do |cell|
        cell.select!
      end
      @current_drag.destroy
    end
  end
  
  def key_press(id)
    case id
    when Gosu::Button::KbEscape
      exit
    when Gosu::Button::KbSpace
      Cell.unselect_all!(color)
    end
    
  end
  
  def click(id)
    if id == Gosu::Button::MsLeft
      clicked_cell  = (FWD::Controller.scene.find(Cell) {
                          |c| c.collide?(mouse_x, mouse_y)} || []).first
      
      selected_cells = (cells.select {|c| c.selected?} || [])
      
      Cell.unselect_all!(color)
      
      return unless clicked_cell
      
      if !selected_cells.empty?
        selected_cells.each do |selected_cell|
          selected_cell.select!
          selected_cell.attack(clicked_cell) unless selected_cell == clicked_cell
        end
      else
        clicked_cell.select! if cells.include?(clicked_cell)
      end
    end
  end
  
end
