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
        expect(MoveAction.strategy_class_for('default')).to be_nil
      end
    end

    context 'class name' do
      it 'returns strategy' do
        expect(MoveAction.strategy_class_for(Car)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_class_for(MiniVan)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_class_for(Vehicle)).to be_nil
      end
    end

    context 'object type' do
      it 'returns strategy' do
        expect(MoveAction.strategy_class_for(car)).to eq(MoveAction::CarStrategy)
        expect(MoveAction.strategy_class_for(mini_van)).to eq(MoveAction::MiniVanStrategy)
        expect(MoveAction.strategy_class_for(vehicle)).to be_nil
      end
    end
  end

  describe '.new_with_strategy' do
    context 'strategy name' do
      it 'returns strategy' do
        expect(MoveAction.new_with_strategy('car', position).strategy).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy('sedan', position).strategy).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy('MINI_VAN', position).strategy).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_with_strategy('invalid name returns default strategy', position).strategy).to be_nil

        expect(MoveActionWithStrategyMatcher.new_with_strategy('Car', position).strategy).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('sedan', position).strategy).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('mini', position).strategy).to be_a(MoveActionWithStrategyMatcher::CarStrategy)

        expect(MoveActionWithStrategyMatcher.new_with_strategy('mini_van', position).strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('mini_va', position).strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('mini_v', position).strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('mini_', position).strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('min', position).strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('mi', position).strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
        expect(MoveActionWithStrategyMatcher.new_with_strategy('m', position).strategy).to be_a(MoveActionWithStrategyMatcher::SimpleStrategy)

        expect(MoveActionWithStrategyMatcher.new_with_strategy('invalid name returns default strategy', position).strategy).to be_a(MoveActionWithStrategyMatcher::SimpleStrategy)
      end
    end

    context 'class name' do
      it 'returns strategy' do
        expect(MoveAction.new_with_strategy(Car, position).strategy).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy(MiniVan, position).strategy).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_with_strategy(Vehicle, position).strategy).to be_nil
      end
    end

    context 'object type' do
      it 'returns strategy' do
        expect(MoveAction.new_with_strategy(car, position).strategy).to be_a(MoveAction::CarStrategy)
        expect(MoveAction.new_with_strategy(mini_van, position).strategy).to be_a(MoveAction::MiniVanStrategy)
        expect(MoveAction.new_with_strategy(vehicle, position).strategy).to be_nil
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
      expect(MoveAction.strategy_names).to eq(['car', 'mini_van'])
    end
    
    it 'returns all loaded strategy names for model with custom strategy matcher' do
      expect(MoveActionWithStrategyMatcher.strategy_names).to eq(['car', 'mini_van', 'simple'])
    end
  end

  describe '::strategy_name' do
    it 'returns all loaded strategy names' do
      expect(MoveAction::CarStrategy.strategy_name).to eq('car')
      expect(MoveAction::MiniVanStrategy.strategy_name).to eq('mini_van')
    end
  end
  
  describe '#strategy=' do
    let(:model) {MoveAction.new(position)}
    let(:model_with_strategy_matcher) {MoveActionWithStrategyMatcher.new(position)}
    
    it 'sets strategy on model instance' do
      model.strategy = 'car'
      expect(model.strategy).to be_a(MoveAction::CarStrategy)
      expect(model.strategy.context).to eq(model)
      model.move
      expect(model.position).to eq(10)
      
      model.position = 0
      model.strategy = 'sedan'
      expect(model.strategy).to be_a(MoveAction::CarStrategy)
      expect(model.strategy.context).to eq(model)
      model.move
      expect(model.position).to eq(10)
      
      model.position = 0
      model.strategy = 'MINI_VAN'
      expect(model.strategy).to be_a(MoveAction::MiniVanStrategy)
      expect(model.strategy.context).to eq(model)
      model.move
      expect(model.position).to eq(9)
      
      model.position = 0
      model.strategy = 'invalid name returns default strategy'
      expect(model.strategy).to be_nil
      expect {model.move}.to raise_error
      expect(model.position).to eq(0)
    end
    
    it 'sets strategy on model instance with strategy matcher and default strategy' do
      model_with_strategy_matcher.strategy = 'car'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(10)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'sedan'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(10)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'mini'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::CarStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(10)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'mini_van'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(9)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'mini_va'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(9)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'mini_v'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(9)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'mini_'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(9)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'min'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(9)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'mi'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::MiniVanStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(9)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'm'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::SimpleStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(1)
    
      model_with_strategy_matcher.position = 0
      model_with_strategy_matcher.strategy = 'invalid name returns default strategy'
      expect(model_with_strategy_matcher.strategy).to be_a(MoveActionWithStrategyMatcher::SimpleStrategy)
      expect(model_with_strategy_matcher.strategy.context).to eq(model_with_strategy_matcher)
      model_with_strategy_matcher.move
      expect(model_with_strategy_matcher.position).to eq(1)
    end
  end
end
