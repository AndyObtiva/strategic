class MoveActionWithStrategyMatcher::MiniVanStrategy < MoveActionWithStrategyMatcher
  strategy_exclusion 'm'
  
  def move
    position += 9
  end
end
