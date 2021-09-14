require 'strategic'

class MoveActionWithStrategyMatcher
  include Strategic
  
  NON_CLASS_CONSTANT = 23 # tests that it is excluded when discovring strategies
  
  default_strategy 'simple'
  
  strategy_matcher do |string_or_class_or_object, strategy_class|
    class_name = self.name
    strategy_name = class_name.split('::').last.sub(/Strategy$/, '').gsub(/([A-Z])/) {|letter| "_#{letter.downcase}"}[1..-1]
    strategy_name_length = strategy_name.length
    possible_keywords = strategy_name_length.times.map {|n| strategy_name.chars.combination(strategy_name_length - n).to_a}.reduce(:+).map(&:join)
    possible_keywords.include?(string_or_class_or_object)
  end

  class CarStrategy
    include Strategic::Strategy
    
    strategy_alias 'sedan'
    strategy_alias 'mini'
    
    strategy_matcher do |string_or_class_or_object, strategy_class|
      class_name = self.name
      strategy_name = class_name.split('::').last.sub(/Strategy$/, '').gsub(/([A-Z])/) {|letter| "_#{letter.downcase}"}[1..-1]
      strategy_name.capitalize == string_or_class_or_object
    end
  
    def move
      context.position += 10
    end
  end

  attr_accessor :position

  def initialize(position)
    @position = position
  end
end
