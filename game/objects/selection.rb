class Selection < Rectangular
  require 'cell'
  
  attr_reader :chosen_cells
  
  on_collision_with(Cell) do |selection, cell|
    selection.select(cell) if selection.collide?(cell.x, cell.y)
  end

  def initialize(x, y, width, height, color)
    super(x, y, width, height, color, false)
    @chosen_cells = Array.new
  end
  
  def select(cell)
    @chosen_cells << cell
  end

  def update
    @width  = mouse_x - @x
    @height = mouse_y - @y
  end
  
end