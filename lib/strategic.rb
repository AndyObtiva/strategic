# Copyright (c) 2020-2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  
module Strategic
  class << self
    attr_reader :rails_auto_strategic
    alias rails_auto_strategic? rails_auto_strategic
  
    def included(klass)
      klass.extend(ClassMethods)
      klass.require_strategies
      rails_mode = klass.respond_to?(:column_names) && klass.column_names.include?('strategy_name')
      if rails_mode
        klass.include(ExtraRailsMethods)
        klass.after_initialize :reload_strategy
      else
        klass.include(ExtraRubyMethods)
      end
    end
    
    def rails_auto_strategic=(value)
      enabled = @rails_auto_strategic.nil? && value
      @rails_auto_strategic = value
      if enabled
        ApplicationRecord.class_eval do
          class << self
            alias inherited_without_strategic inherited
            def inherited(klass)
              inherited_without_strategic(klass)
              klass.include(Strategic)
            end
          end
        end
      end
    end
  end
  
  module ExtraRailsMethods
    def strategy_name=(string)
      self['strategy_name'] = string
      strategy_class = self.class.strategy_class_for(string)
      @strategy = strategy_class&.new(self)
    end
  end
  
  module ExtraRubyMethods
    attr_reader :strategy_name
    
    def strategy_name=(string)
      @strategy_name = string
      strategy_class = self.class.strategy_class_for(string)
      @strategy = strategy_class&.new(self)
    end
  end

  module ClassMethods
    def strategy_matcher(&matcher_block)
      if matcher_block.nil?
        @strategy_matcher
      else
        @strategy_matcher = matcher_block
      end
    end
    
    def default_strategy(string_or_class_or_object = nil)
      if string_or_class_or_object.nil?
        @default_strategy
      else
        @default_strategy = strategy_class_for(string_or_class_or_object)
      end
    end
    
    def strategy_matcher_for_any_strategy?
      !!(strategy_matcher || strategies.any?(&:strategy_matcher))
    end
  
    def require_strategies
      klass_path = caller[1].split(':').first
      strategy_path = File.expand_path(File.join(klass_path, '..', Strategic.underscore(self.name), '**', '*.rb'))
      Dir.glob(strategy_path) do |strategy|
        Object.const_defined?(:Rails) ? require_dependency(strategy) : require(strategy)
      end
    end

    def strategy_class_for(string_or_class_or_object)
      strategy_class = strategy_matcher_for_any_strategy? ? strategy_class_with_strategy_matcher(string_or_class_or_object) : strategy_class_without_strategy_matcher(string_or_class_or_object)
      strategy_class ||= strategies.detect { |strategy| strategy.strategy_aliases.include?(string_or_class_or_object) }
      strategy_class ||= default_strategy
    end
    
    def strategy_class_with_strategy_matcher(string_or_class_or_object)
      strategies.detect do |strategy|
        match = strategy.strategy_aliases.include?(string_or_class_or_object)
        match ||= strategy&.strategy_matcher&.call(string_or_class_or_object) || (strategy_matcher && strategy.instance_exec(string_or_class_or_object, &strategy_matcher))
        # match unless excluded or included by another strategy as an alias
        match unless strategy.strategy_exclusions.include?(string_or_class_or_object) || (strategies - [strategy]).map(&:strategy_aliases).flatten.include?(string_or_class_or_object)
      end
    end
    
    def strategy_class_without_strategy_matcher(string_or_class_or_object)
      if string_or_class_or_object.is_a?(String)
        strategy_class_name = string_or_class_or_object.downcase
      elsif string_or_class_or_object.is_a?(Class)
        strategy_class_name = string_or_class_or_object.name
      else
        strategy_class_name = string_or_class_or_object.class.name
      end
      return nil if strategy_class_name.to_s.strip.empty?
      begin
        class_name = "::#{self.name}::#{Strategic.classify(strategy_class_name)}Strategy"
        class_eval(class_name)
      rescue NameError
        # No Op
      end
    end

    def new_with_strategy(string_or_class_or_object, *args, &block)
      new(*args, &block).tap do |model|
        model.strategy = string_or_class_or_object
      end
    end

    def strategies
      constants.map do |constant_symbol|
        const_get(constant_symbol)
      end.select do |constant|
        constant.respond_to?(:ancestors)
      end.select do |constant|
        constant.ancestors.include?(Strategic::Strategy) && constant.name.split('::').last.end_with?('Strategy') && constant.name.split('::').last != 'Strategy' # has to be something like PrefixStrategy
      end.sort_by(&:strategy_name)
    end

    def strategy_names
      strategies.map(&:strategy_name)
    end
    
  end
  
  def strategy=(string_or_class_or_object)
    strategy_class = self.class.strategy_class_for(string_or_class_or_object)
    self.strategy_name = strategy_class&.strategy_name
  end
      
  def strategy
    @strategy
  end
  
  def reload_strategy
    self.strategy = strategy_name
  end
  
  def method_missing(method_name, *args, &block)
    if strategy&.respond_to?(method_name, *args, &block)
      strategy.send(method_name, *args, &block)
    else
      begin
        super
      rescue => e
        raise "No strategy is set to handle the method #{method_name} with args #{args.inspect} and block #{block.inspect} / " + e.message
      end
    end
  end
    
  def respond_to?(method_name, *args, &block)
    strategy&.respond_to?(method_name, *args, &block) || super
  end

  private

  def self.classify(text)
    text.split("_").map {|word| "#{word[0].upcase}#{word[1..-1]}"}.join
  end

  def self.underscore(text)
    text.chars.reduce('') {|output,c| !output.empty? && c.match(/[A-Z]/) ? output + '_' + c : output + c}.downcase
  end
end

require_relative 'strategic/strategy'
