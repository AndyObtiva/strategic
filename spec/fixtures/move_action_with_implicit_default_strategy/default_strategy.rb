class MoveActionWithImplicitDefaultStrategy
  class DefaultStrategy
    include Strategic::Strategy
    
    def move
      context.position += 10
    end
  end
end
