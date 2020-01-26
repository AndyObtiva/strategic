require 'strategic'

class MoveAction
  include Strategic

  class CarStrategy < MoveAction
    def move
      position += 10
    end
  end

  attr_reader :position

  def initialize(position)
    @position = position
  end

  def move
    position += 1
  end
end
