# TODO

- Consider providing the option to set a strategy as a block
- Add `#strategy_name` method on `Strategic::Strategy` classes
- Customize `strategy_name` attribute name (e.g. `sort_strategy_name`)
- Support defining DefaultStrategy inside the Strategic class body (right now, it is expected to be an external class in an external file)
- Support multiple strategies (with multiple strategy name attributes/columns)
- Configuration option of `Strategic::rails_auto_strategic = true` to indicate whether to include module mixins automatically by convention for Strategic and Strategic::Strategy in Rails applications (thus software engineer only has to create model_name/xyz_strategy.rb files and that enables strategies automatically assuming a strategy_name attribute or column on model)
- Utilize `super_module` gem (once it is updated to not replay class methods automatically)
