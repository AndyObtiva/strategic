module Strategic
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  module ClassMethods
    def strategy_for(string_or_class_or_object)
      if string_or_class_or_object.is_a?(String)
        strategy_class_name = string_or_class_or_object
      elsif string_or_class_or_object.is_a?(Class)
        strategy_class_name = string_or_class_or_object.name
      else
        strategy_class_name = string_or_class_or_object.class.name
      end
      class_name ||= "::#{self.name}::#{classify(strategy_class_name)}Strategy"
      class_eval(class_name)
    rescue NameError
      self
    end

    def new_with_strategy(string_or_class_or_object, *args, &block)
      strategy_for(string_or_class_or_object).new(*args, &block)
    end

    private

    def classify(text)
      text.split("_").map {|word| "#{word[0].upcase}#{word[1..-1]}"}.join
    end
  end
end
