require 'strategic'

class MoveActionWithStrategyMatcher
  include Strategic
  
  strategy_matcher do |string_or_class_or_object, strategy_class|
    class_name = self.name
    strategy_name = class_name.split('::').last.sub(/Strategy$/, '').gsub(/([A-Z])/) {|letter| "_#{letter.downcase}"}[1..-1]
    strategy_name_length = strategy_name.length
    possible_keywords = strategy_name_length.times.map {|n| strategy_name.chars.combination(strategy_name_length - n).to_a}.reduce(:+).map(&:join)
    possible_keywords.include?(string_or_class_or_object)
  end

  class CarStrategy < MoveActionWithStrategyMatcher
    strategy_alias 'sedan'
    
    strategy_matcher do |string_or_class_or_object, strategy_class|
      class_name = self.name
      strategy_name = class_name.split('::').last.sub(/Strategy$/, '').gsub(/([A-Z])/) {|letter| "_#{letter.downcase}"}[1..-1]
      strategy_name.capitalize == string_or_class_or_object
    end
    
  
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
