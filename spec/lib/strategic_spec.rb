require_relative '../spec_helper'

RSpec.describe Strategic do
  class Vehicle
    attr_reader :position

    def initialize(position = 0)
      @position = position
    end
  end

  class Car < Vehicle
  end

  class Truck < Vehicle
  end

  class MiniVan < Vehicle
  end

  class MoveAction
    include Strategic

    attr_reader :vehicle

    def initialize(vehicle)
      @vehicle = vehicle
    end

    def move
      vehicle.position += 1
    end
  end

  class MoveAction::CarStrategy < MoveAction
    def move
      vehicle.position += 10
    end
  end

  class MoveAction::TruckStrategy < MoveAction
    def move
      vehicle.position += 8
    end
  end

  class MoveAction::MiniVanStrategy < MoveAction
    def move
      vehicle.position += 9
    end
  end

  describe '.strategy_for' do
    context 'strategy name' do
      it 'returns strategy' do
        expect(MoveAction.strategy_for('car')).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_for('truck')).to eq(MoveAction::TruckStrategy)
        expect(MoveAction.strategy_for('mini_van')).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_for('other')).to eq(MoveAction)
      end
    end
    context 'class name' do
      it 'returns strategy' do
        expect(MoveAction.strategy_for(Car)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_for(Truck)).to eq(MoveAction::TruckStrategy)
        expect(MoveAction.strategy_for(MiniVan)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_for(Vehicle)).to eq(MoveAction)
      end
    end
    context 'object type' do
      it 'returns strategy' do
        expect(MoveAction.strategy_for(Car.new)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_for(Truck.new)).to eq(MoveAction::TruckStrategy)
        expect(MoveAction.strategy_for(MiniVan.new)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_for(Vehicle.new)).to eq(MoveAction)
      end
    end
    context 'directory strategies'
  end
  describe '.new_with_strategy'
end
