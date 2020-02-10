# Strategic (Painless Strategy Pattern in Ruby and Rails)
[![Gem Version](https://badge.fury.io/rb/strategic.svg)](http://badge.fury.io/rb/strategic)

if/case conditionals can get really hairy in highly sophisticated business domains.
Domain model inheritance can help remedy the problem, but dumping all
logic variations in the same domain models can cause a maintenance nightmare.
Thankfully, Strategy Pattern as per the Gang of Four solves the problem by externalizing logic variations to
separate classes outside the domain models.

Still, there are a number of challenges with repeated implementation of Strategy Pattern:
- Making domain models aware of newly added strategies without touching their
code (Open/Closed Principle).
- Fetching the right strategy without use of conditionals.
- Avoiding duplication of strategy dispatch code for multiple domain models
- Have different strategies mirror an existing domain model hierarchy

`strategic` solves these problems by offering:
- Strategy Pattern support through a Ruby mixin and strategy path/name convention
- Automatic discovery of strategies based on path/name convention
- Ability to fetch needed strategy without use of conditionals
- Ability to fetch a strategy by name or by object type to mirror
- Plain Ruby and Ruby on Rails support

`strategic` enables you to make any existing domain model "strategic",
externalizing all logic concerning algorithmic variations into separate strategy
classes that are easy to find, maintain and extend.

### Example

<img src="strategic-example.png"
alt="Strategic Example" />

1. Class to strategize is: `TaxCalculator`

```ruby
class TaxCalculator
  include Strategic

  def tax_for(amount)
    amount * 0.09
  end
end
```

2. Directory to create strategies under: `tax_calculator`

3. Strategy class:

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

4. Get needed strategy:

```ruby
tax_calculator_strategy_class = TaxCalculator.strategy_class_for('us')
```

5. Instantiate strategy:

```ruby
tax_calculator_strategy = strategy_class.new('IL')
```

6. Invoke strategy method:

```ruby
tax = tax_calculator_strategy.tax_for(39.78)
```

**Alternative approach using `new_strategy`:**

```ruby
tax_calculator_strategy = TaxCalculator.new_strategy('US', 'IL')
tax = tax_calculator_strategy.tax_for(39.78)
```

**Default strategy for a strategy name that has no strategy class is TaxCalculator**

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

## Release Notes

**0.8.0:** Initial version with `strategy_class_for`, `new_strategy`, `strategies`, and `strategy_names`

## TODO

None

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

## Copyright

Copyright (c) 2020 Andy Maleh. See LICENSE.txt for
further details.
