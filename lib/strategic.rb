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
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.require_strategies
  end

  module ClassMethods
    def strategy_alias(alias_string_or_class_or_object)
      strategy_aliases << alias_string_or_class_or_object
    end
    
    def strategy_aliases
      @strategy_aliases ||= []
    end
  
    def strategy_exclusion(exclusion_string_or_class_or_object)
      strategy_exclusions << exclusion_string_or_class_or_object
    end
    
    def strategy_exclusions
      @strategy_exclusions ||= []
    end
    
    def strategy_matcher(&matcher_block)
      if block_given?
        @strategy_matcher = matcher_block
      else
        @strategy_matcher
      end
    end
  
    def require_strategies
      klass_path = caller[1].split(':').first
      strategy_path = File.expand_path(File.join(klass_path, '..', Strategic.underscore(self.name), '**', '*.rb'))
      Dir.glob(strategy_path) do |strategy|
        Object.const_defined?(:Rails) ? require_dependency(strategy) : require(strategy)
      end
    end

    def strategy_class_for(string_or_class_or_object)
      strategy_class = nil
      if strategy_matcher
        strategy_class = strategies.detect do |strategy|
          match = strategy&.strategy_matcher&.call(string_or_class_or_object)
          match ||= strategy.instance_exec(string_or_class_or_object, &strategy_matcher)
          match unless strategy.strategy_exclusions.include?(string_or_class_or_object)
        end
      else
        if string_or_class_or_object.is_a?(String)
          strategy_class_name = string_or_class_or_object.downcase
        elsif string_or_class_or_object.is_a?(Class)
          strategy_class_name = string_or_class_or_object.name
        else
          strategy_class_name = string_or_class_or_object.class.name
        end
        begin
          class_name = "::#{self.name}::#{Strategic.classify(strategy_class_name)}Strategy"
          strategy_class = class_eval(class_name)
        rescue NameError
          # No Op
        end
      end
      strategy_class ||= strategies.detect { |strategy| strategy.strategy_aliases.include?(string_or_class_or_object) }
      strategy_class ||= self
    end

    def new_strategy(string_or_class_or_object, *args, &block)
      strategy_class_for(string_or_class_or_object).new(*args, &block)
    end

    def strategies
      constants.map do |constant_symbol|
        const_get(constant_symbol)
      end.select do |constant|
        constant.respond_to?(:ancestors) && constant.ancestors.include?(self)
      end
    end

    def strategy_names
      strategies.map(&:strategy_name)
    end
    
    def strategy_name
      Strategic.underscore(name.split(':').last).sub(/_strategy$/, '')
    end
  end

  private

  def self.classify(text)
    text.split("_").map {|word| "#{word[0].upcase}#{word[1..-1]}"}.join
  end

  def self.underscore(text)
    text.chars.reduce('') {|output,c| !output.empty? && c.match(/[A-Z]/) ? output + '_' + c : output + c}.downcase
  end
end
