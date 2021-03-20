class MoveActionWithStrategyMatcher::MiniVanStrategy
  include Strategic::Strategy
  
  strategy_exclusion 'm'
  
  def move
    position += 9
  end
end
