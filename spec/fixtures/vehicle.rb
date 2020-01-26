class Vehicle
  attr_reader :make, :model, :position

  def initialize(make:, model:, position: 0)
    @position = position
  end
end
