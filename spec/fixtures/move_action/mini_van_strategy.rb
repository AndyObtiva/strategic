class MoveAction::MiniVanStrategy
  include Strategic::Strategy
  
  def move
    context.position += 9
  end
end
