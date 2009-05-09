class Score < FWD::Text
  def initialize(x,y)
    super(x,y, 0.0)
  end
  
  def score
    @text
  end
  
  def score=(new_score)
    @text = new_score
  end
end