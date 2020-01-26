require_relative '../spec_helper'

RSpec.describe Strategic do
  class Vehicle
    attr_reader :make, :model, :position

    def initialize(make:, model:, position: 0)
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

    attr_reader :position

    def initialize(position)
      @position = position
    end

    def move
      position += 1
    end
  end

  class MoveAction::CarStrategy < MoveAction
    def move
      position += 10
    end
  end

  class MoveAction::TruckStrategy < MoveAction
    def move
      position += 8
    end
  end

  class MoveAction::MiniVanStrategy < MoveAction
    def move
      position += 9
    end
  end

  let(:vehicle_attributes) { {make: 'NASA', model: 'Mars Curiosity Rover'} }
  let(:car_attributes) { {make: 'Mitsubishi', model: 'Eclipse'} }
  let(:truck_attributes) { {make: 'Nissan', model: 'Pathfinder'} }
  let(:mini_van_attributes) { {make: 'Toyota', model: 'Previa'} }

  let(:vehicle) { Vehicle.new(vehicle_attributes) }
  let(:car) { Car.new(vehicle_attributes) }
  let(:truck) { Truck.new(truck_attributes) }
  let(:mini_van) { MiniVan.new(mini_van_attributes) }

  let(:position) { 0 }

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
        expect(MoveAction.strategy_for(car)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_for(truck)).to eq(MoveAction::TruckStrategy)
        expect(MoveAction.strategy_for(mini_van)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_for(vehicle)).to eq(MoveAction)
      end
    end
    
    context 'directory strategies'
  end

  describe '.new_with_strategy' do
    context 'strategy name' do
      it 'returns strategy' do
        expect(MoveAction.new_with_strategy('car', position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy('truck', position)).to be_a(MoveAction::TruckStrategy)
        expect(MoveAction.new_with_strategy('mini_van', position)).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_with_strategy('other', position)).to be_a(MoveAction)
      end
    end

    context 'class name' do
      it 'returns strategy' do
        expect(MoveAction.new_with_strategy(Car, position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy(Truck, position)).to be_a(MoveAction::TruckStrategy)
        expect(MoveAction.new_with_strategy(MiniVan, position)).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_with_strategy(Vehicle, position)).to be_a(MoveAction)
      end
    end

    context 'object type' do
      it 'returns strategy' do
        expect(MoveAction.new_with_strategy(car, position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy(truck, position)).to be_a(MoveAction::TruckStrategy)
        expect(MoveAction.new_with_strategy(mini_van, position)).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_with_strategy(vehicle, position)).to be_a(MoveAction)
      end
    end
  end
end
