# TODO

- Allow strategies to specify additional strings or objects they match (other than their class name convention) to enable instantating via `new_strategy`
Example:
```ruby
class StrategySuperClass::SomeStrategy < StrategySuperClass
  strategy_for 'Something'
  strategy_for 777
  strategy_for do |object|
    object.to_i.odd?
  end
end
```
