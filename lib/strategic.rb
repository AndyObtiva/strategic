module Strategic
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.require_strategies
  end

  module ClassMethods
    def require_strategies
      klass_path = caller[1].split(':').first
      strategy_path = File.expand_path(File.join(klass_path, '..', Strategic.underscore(self.name), '**', '*.rb'))
      Dir.glob(strategy_path) do |strategy|
        Object.const_defined?(:Rails) ? require_dependency(strategy) : require(strategy)
      end
    end

    def strategy_for(string_or_class_or_object)
      if string_or_class_or_object.is_a?(String)
        strategy_class_name = string_or_class_or_object
      elsif string_or_class_or_object.is_a?(Class)
        strategy_class_name = string_or_class_or_object.name
      else
        strategy_class_name = string_or_class_or_object.class.name
      end
      class_name ||= "::#{self.name}::#{Strategic.classify(strategy_class_name)}Strategy"
      class_eval(class_name)
    rescue NameError
      self
    end

    def new_with_strategy(string_or_class_or_object, *args, &block)
      strategy_for(string_or_class_or_object).new(*args, &block)
    end

    def strategies
      constants.map do |constant_symbol|
        const_get(constant_symbol)
      end.select do |constant|
        constant.respond_to?(:ancestors) && constant.ancestors.include?(self)
      end
    end

    def strategy_names
      strategies.map(&:name).map { |class_name| Strategic.underscore(class_name.split(':').last).sub(/_strategy$/, '') }
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
