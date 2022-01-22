# TODO

- Support Rails 7
- Support default strategy being Model::DefaultStrategy by convention if no `default_strategy` is set
- Customize `strategy_name` attribute name (e.g. `sort_strategy_name`)
- Support multiple strategies (with multiple strategy name attributes/columns)
- Configuration option of `Strategic::rails_auto_strategic = true` to indicate whether to include module mixins automatically by convention for Strategic and Strategic::Strategy in Rails applications (thus software engineer only has to create model_name/xyz_strategy.rb files and that enables strategies automatically assuming a strategy_name attribute or column on model)
- Utilize super_module gem (once it is updated to not replay class methods automatically)
