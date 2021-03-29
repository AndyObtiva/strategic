# Change Log

## 1.0.0

- Improve design to better match the authentic Gang of Four Strategy Pattern with `Strategic::Strategy` module, removing the need for inheritance.
- `#strategy=`/`#strategy` enable setting/getting strategy on model
- `#context` enables getting strategic model instance on strategy just as per the GOF Design Pattern
- `default_strategy` class body method to set default strategy
- Filter strategies by ones ending with `Strategy` in class name

## 0.9.1

- `strategy_name` returns parsed strategy name of current strategy class
- `strategy_matcher` ignores a strategy if it found another strategy already matching by strategy_alias

## 0.9.0

- `strategy_matcher` block support that enables any strategy to specify a custom matcher (or the superclass of all strategies instead)
- `strategy_exclusion` class method support that enables any strategy to specify exclusions from the custom `strategy_matcher`
- `strategy_alias` class method support that enables any strategy to specify extra aliases (used by superclass's `strategy_class_for` method)

## 0.8.0

- Initial version with `strategy_class_for`, `new_strategy`, `strategies`, and `strategy_names`
