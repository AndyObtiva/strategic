class MoveActionWithStrategyMatcher::MiniVanStrategy
  include Strategic::Strategy
  
  strategy_exclusion 'm'
  
  def move
    context.position += 9
  end
end
