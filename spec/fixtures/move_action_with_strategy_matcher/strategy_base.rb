class MoveActionWithStrategyMatcher::StrategyBase
  include Strategic::Strategy
  
  # default implementation
  def move
    context.position += 1
  end
end
