class Cell < Circle
  require 'bullet'
  
  NEUTRAL_COLOR = Gosu::Color.new(150,150,150)
  
  claims(:bullets, Bullet).identified_by(:emitting_cell)
  
  def initialize(x, y, size, player, cells = 0)
    super(x, y, size, player.color)
    @selection_color = Gosu::Color.new(122,122,122)
    @cells           = cells
    @text            = FWD::Text.new(@x, @y, @cells)
  end
  
  def update
    @text.text = @cells.to_i
    @cells += 0.0003 * @size unless neutral?
  end
  
  def draw
    super
    draw_circle(@x - 1, @y - 1, @size + 2, @size + 2, @selection_color, true) if @selected
    @text.draw
  end
  
  def selected?
    !!@selected
  end
  
  def select!
    # self.class.unselect_all!(color)
    @selected = true
  end
  
  def unselect!
    @selected = false
  end
  
  def self.unselect_all!(color)
    FWD::Controller.scene.find(self) {|c| c.color == color}.each do |cell|
      cell.unselect!
    end
  end
  
  def opponent_of?(cell)
    color != cell.color
  end
  
  def attack(target_cell)
    power = @cells.to_i / 2
    return unless power > 0
    
    fresh_bullet = (bullets.select {|b| collide?(b.x, b.y) && 
                                       b.target_cell == target_cell} || [])[0]
    if fresh_bullet
      fresh_bullet.increase_power(power)
    else
      FWD::Controller.spawn(Bullet.new(self, target_cell, power))
    end
    @cells -= power
  end
  
  def power_up(bullet)
    @cells += bullet.power
  end
  
  def power_down(bullet)
    @cells -= bullet.power
    if @cells.to_i < 1
      if @cells.to_i == 0
        @color = NEUTRAL_COLOR
      else
        @color = bullet.color
        @cells = @cells.abs
        unselect!
      end
    end
  end
  
  def neutral?
    @color == NEUTRAL_COLOR
  end
end
