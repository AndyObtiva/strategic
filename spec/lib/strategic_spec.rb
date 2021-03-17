require_relative '../spec_helper'
require_relative '../fixtures/vehicle'
require_relative '../fixtures/car'
require_relative '../fixtures/mini_van'
require_relative '../fixtures/move_action'
require_relative '../fixtures/move_action_with_strategy_matcher'

RSpec.describe Strategic do
  let(:vehicle_attributes) { {make: 'NASA', model: 'Mars Curiosity Rover'} }
  let(:car_attributes) { {make: 'Mitsubishi', model: 'Eclipse'} }
  let(:mini_van_attributes) { {make: 'Toyota', model: 'Tundra'} }

  let(:vehicle) { Vehicle.new(**vehicle_attributes) }
  let(:car) { Car.new(**vehicle_attributes) }
  let(:mini_van) { MiniVan.new(**mini_van_attributes) }

  let(:position) { 0 }

  describe '.strategy_class_for' do
    context 'strategy name' do
      it 'returns strategy' do
        expect(MoveAction.strategy_class_for('car')).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_class_for('mini_van')).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_class_for('default')).to eq(MoveAction)
      end
    end

    context 'class name' do
      it 'returns strategy' do
        expect(MoveAction.strategy_class_for(Car)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_class_for(MiniVan)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_class_for(Vehicle)).to eq(MoveAction)
      end
    end

    context 'object type' do
      it 'returns strategy' do
        expect(MoveAction.strategy_class_for(car)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_class_for(mini_van)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_class_for(vehicle)).to eq(MoveAction)
      end
    end
  end

  describe '.new_strategy' do
    context 'strategy name' do
      it 'returns strategy' do
        expect(MoveAction.new_strategy('car', position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_strategy('sedan', position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_strategy('MINI_VAN', position)).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_strategy('invalid name returns default strategy', position)).to be_a(MoveAction)
        
        expect(MoveActionWithStrategyMatcher.new_strategy('Car', position)).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('sedan', position)).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('mini_van', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('mini_va', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('mini_v', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('mini_', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('mini', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('min', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('mi', position)).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_strategy('m', position).class).to eq(MoveActionWithStrategyMatcher)
        
        expect(MoveActionWithStrategyMatcher.new_strategy('invalid name returns default strategy', position)).to be_a(MoveActionWithStrategyMatcher)
      end
    end

    context 'class name' do
      it 'returns strategy' do
        expect(MoveAction.new_strategy(Car, position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_strategy(MiniVan, position)).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_strategy(Vehicle, position)).to be_a(MoveAction)
      end
    end

    context 'object type' do
      it 'returns strategy' do
        expect(MoveAction.new_strategy(car, position)).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_strategy(mini_van, position)).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_strategy(vehicle, position)).to be_a(MoveAction)
      end
    end
  end

  describe '::strategies' do
    it 'returns all loaded strategies' do
      expect(MoveAction.strategies).to match_array([MoveAction::CarStrategy, MoveAction::MiniVanStrategy])
    end
  end

  describe '::strategy_names' do
    it 'returns all loaded strategy names' do
      expect(MoveAction.strategy_names).to match_array(['car', 'mini_van'])
    end
  end

  describe '::strategy_name' do
    it 'returns all loaded strategy names' do
      expect(MoveAction::CarStrategy.strategy_name).to eq('car')
      expect(MoveAction::MiniVanStrategy.strategy_name).to eq('mini_van')
    end
  end
end
