class MoveActionWithStrategyMatcher::SimpleStrategy
  include Strategic::Strategy
  
  def move
    context.position += 1
  end
end
