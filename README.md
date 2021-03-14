# Strategic (Painless Strategy Pattern in Ruby and Rails)
[![Gem Version](https://badge.fury.io/rb/strategic.svg)](http://badge.fury.io/rb/strategic)
[![Build Status](https://travis-ci.com/AndyObtiva/strategic.svg?branch=master)](https://travis-ci.com/AndyObtiva/strategic?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/AndyObtiva/strategic/badge.svg?branch=master)](https://coveralls.io/github/AndyObtiva/strategic?branch=master)

(Note: this gem is a very early alpha work in progress and may change API in the future)

`if`/`case` conditionals can get really hairy in highly sophisticated business domains.
Object-oriented inheritance helps remedy the problem, but dumping all
logic variations in subclasses can cause a maintenance nightmare.
Thankfully, the Strategy Pattern as per the [Gang of Four book](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612) solves the problem by externalizing logic to
separate classes outside the domain models.

Still, there are a number of challenges with "repeated implementation" of the Strategy Pattern:
- Making domain models aware of newly added strategies without touching their
code (Open/Closed Principle).
- Fetching the right strategy without the use of conditionals.
- Avoiding duplication of strategy dispatch code for multiple domain models
- Have strategies mirror an existing domain model inheritance hierarchy

`strategic` solves these problems by offering:
- Strategy Pattern support through a Ruby mixin and strategy path/name convention
- Automatic discovery of strategies based on path/name convention
- Ability to fetch needed strategy without use of conditionals
- Ability to fetch a strategy by name or by object type to mirror
- Plain Ruby and Ruby on Rails support

`Strategic` enables you to make any existing domain model "strategic",
externalizing all logic concerning algorithmic variations into separate strategy
classes that are easy to find, maintain and extend while honoring the Open/Closed Principle.

### Example

<img src="strategic-example.png"
alt="Strategic Example" />

1. Include `Strategic` module in the Class to strategize: `TaxCalculator`

```ruby
class TaxCalculator
  include Strategic

  def tax_for(amount)
    amount * 0.09
  end
end
```

2. Now, you can add strategies under this directory without having to modify the original class: `tax_calculator`

3. Add strategy classes under the namespace matching the original class name (`TaxCalculator`) and extending the original class (`TaxCalculator`) just to take advantage of default logic in it:

```ruby
class TaxCalculator::UsStrategy < TaxCalculator
  def initialize(state)
    @state = state
  end
  def tax_for(amount)
    amount * state_rate
  end
  # ... more code follows
end

class TaxCalculator::CanadaStrategy < TaxCalculator
  def initialize(province)
    @province = province
  end
  def tax_for(amount)
    amount * (gst + qst)
  end
  # ... more code follows
end
```

4. In client code, obtain the needed strategy by underscored string reference minus the word strategy (e.g. UsStrategy becomes simply 'us'):

```ruby
tax_calculator_strategy_class = TaxCalculator.strategy_class_for('us')
```

5. Instantiate the strategy object:

```ruby
tax_calculator_strategy = strategy_class.new('IL')
```

6. Invoke the strategy overridden method:

```ruby
tax = tax_calculator_strategy.tax_for(39.78)
```

**Alternative approach using `new_strategy(strategy_name, *initializer_args)`:**

```ruby
tax_calculator_strategy = TaxCalculator.new_strategy('US', 'IL')
tax = tax_calculator_strategy.tax_for(39.78)
```

**Default strategy for a strategy name that has no strategy class is the superclass: `TaxCalculator`**

```ruby
tax_calculator_strategy_class = TaxCalculator.strategy_class_for('France')
tax_calculator_strategy = tax_calculator_strategy_class.new
tax = tax_calculator_strategy.tax_for(100.0) # returns 9.0 from TaxCalculator
```

## Setup

### Option 1: Bundler

Add the following to bundler's `Gemfile`.

```ruby
gem 'strategic', '~> 0.8.0'
```

### Option 2: Manual

Or manually install and require library.

```bash
gem install strategic -v0.8.0
```

```ruby
require 'strategic'
```

### Usage

Steps:
1. Have the original class you'd like to strategize include Strategic
2. Create a directory matching the class underscored file name minus the '.rb' extension
3. Create a strategy class under that directory, which:
 - Lives under the original class namespace
 - Extends the original class to strategize
 - Has a class name that ends with `Strategy` suffix (e.g. `NewCustomerStrategy`)
4. Get needed strategy class using `strategy_class_for` class method taking strategy name (any case) or related object/type (can call `strategy_names` class method to obtain strategy names)
5. Instantiate strategy with needed constructor parameters
6. Invoke strategy method needed

Alternative approach:

Combine steps 4 and 5 using `new_strategy` method, which takes both strategy name
and constructor parameters

Passing an invalid strategy name to `strategy_class_for` returns original class as the default
strategy.

## API

- `StrategicSuperClass::strategy_class_for(string_or_class_or_object)`: selects a strategy class based on a string (e.g. 'us' selects USStrategy) or alternatively a class/object if you have a mirror hierarchy for the strategy hierarchy
- `StrategicSuperClass::new_strategy(string_or_class_or_object, *args, &block)`: instantiates a strategy based on a string/class/object and strategy constructor args
- `StrategicSuperClass::strategies`: returns list of strategies discovered by convention (nested under a namespace matching the superclass name)
- `StrategicSuperClass::strategy_names`: returns list of strategy names (strings) discovered by convention (nested under a namespace matching the superclass name)

## TODO

[TODO.md](TODO.md)

## Change Log

[CHANGELOG.md](CHANGELOG.md)

## Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Change directory into project
* Run `gem install bundler && bundle && rake` and make sure RSpec tests are passing
* Start a feature/bugfix branch.
* Write RSpec tests, Code, Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## License

[MIT](LICENSE.txt)

Copyright (c) 2020-2021 Andy Maleh.
