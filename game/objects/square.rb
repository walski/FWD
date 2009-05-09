class Square < Rectangular
  attr_accessor :size
  
  def initialize(x, y, size, color)
    @size = size
    super(x, y, size, size, color)
  end
end