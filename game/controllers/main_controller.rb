class MainController < FWD::Controller
  def initialize
    players = [Player.new(Gosu::Color.new(255,0,0)), 
              Player.new(Gosu::Color.new(0,255,0))]
    FWD::Service::MouseKeyboard.register(players.first)
    
    players.each {|p| spawn p}

    spawn Cursor.new, 1000
    
    spawn Cell.new(100, 100,         50, players.first, 100)
    spawn Cell.new(500, 300,        100, players.first)
    spawn Cell.new(300, 300,         80, players.last, 22)
    c = Cell.new( 40, height - 50, 30, players.last)
    spawn c
    c.select!
  end
  
end