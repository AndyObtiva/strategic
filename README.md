# Strategic (Painless Strategy Pattern in Ruby and Rails)
[![Gem Version](https://badge.fury.io/rb/strategic.svg)](http://badge.fury.io/rb/strategic)

if/case conditionals can get really hairy in highly sophisticated business domains.
Domain model inheritance can help remedy the problem, but you don't want to dump all
logic variations in the same domain models as that can create a maintenance nightmare.
Strategy Pattern solves that problem by externalizing logic variations to
separate classes outside the domain models.

Still, there are a number of challenges with repeated implementation of Strategy Pattern:
- Making domain models aware of newly added strategies without touching their
code (Open/Closed Principle).
- Fetching the right strategy without use of conditionals.
- Avoiding duplication of strategy dispatch code for multiple domain models
- Have different strategies mirroring an existing domain model hierarchy

`strategic` solves these problems by offering:
- Strategy Pattern support through including a Ruby module (trait mixin)
- Automatic discovery of strategies based on a directory/namespace convention
- Ability to fetch the needed strategy without use of conditionals
- Ability to fetch a strategy by name or by object type to strategize by
- Plain Ruby and Ruby on Rails support

`strategic` enables you to make any existing domain model "strategic", to
externalize all logic concerning algorithmic variations into separate strategy
classes that are easy to maintain and extend.

## Instructions

### Option 1: Bundler

Add the following to bundler's `Gemfile`.

```ruby
gem 'strategic', '~> 1.0.0'
```

### Option 2: Manual

Or manually install and require library.

```bash
gem install strategic -v1.0.0
```

```ruby
require 'strategic'
```

### Usage

TODO

## Release Notes

TODO

## TODO

TODO

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
