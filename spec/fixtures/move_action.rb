require 'strategic'

class MoveAction
  include Strategic
  
  NON_CLASS_CONSTANT = 23 # tests that it is excluded when discovring strategies
  
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
end
