require 'strategic'

class MoveAction
  include Strategic
  
  class CarStrategy
    include Strategic::Strategy
    
    strategy_alias 'sedan'
  
    def move
      context.position += 10
    end
  end

  attr_accessor :position

  def initialize(position)
    @position = position
  end

  def move
    position += 1
  end
end
