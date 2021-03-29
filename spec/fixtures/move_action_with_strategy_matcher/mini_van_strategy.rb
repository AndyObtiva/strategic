require_relative 'strategy_base'

class MoveActionWithStrategyMatcher::MiniVanStrategy < MoveActionWithStrategyMatcher::StrategyBase
  strategy_exclusion 'm'
  
  def move
    context.position += 9
  end
end
