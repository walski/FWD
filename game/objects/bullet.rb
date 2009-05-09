class Bullet < Circle
  require 'cell'
  SPEED = 500
  
  on_collision_with(Cell) do |bullet, cell|
    if bullet.emitting_cell != cell
      if cell.opponent_of?(bullet)
        cell.power_down(bullet)
      else
        cell.power_up(bullet)
      end
      bullet.destroy
    end
  end
    
    
  attr_reader :emitting_cell, :target_cell, :power

  def initialize(emitting_cell, target_cell, power)
    super(emitting_cell.x, emitting_cell.y, 5, emitting_cell.color)
    
    @emitting_cell = emitting_cell
    @target_cell   = target_cell
    @angle         = Gosu::angle(@x, @y, target_cell.x, target_cell.y)
    @power         = power
    @text          = FWD::Text.new(@x, @y, @power)
    @start         = Time.now.to_f
    @start_x       = @x
    @start_y       = @y
  end
  
  def draw
    super
    @text.draw
  end
  
  def update
    offset = (Time.now.to_f - @start) * SPEED
    @x = @start_x + Gosu::offset_x(@angle, offset)
    @y = @start_y + Gosu::offset_y(@angle, offset)
    @text.x = @x
    @text.y = @y
  end
  
  def increase_power(power_upgrade)
    @power     += power_upgrade
    @text.text  = @power
  end
 
end
