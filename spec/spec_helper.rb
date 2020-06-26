require 'simplecov'
require 'simplecov-lcov'
require 'coveralls' if ENV['TRAVIS']

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatters = [SimpleCov::Formatter::LcovFormatter]
SimpleCov.formatters << Coveralls::SimpleCov::Formatter if ENV['TRAVIS']
SimpleCov.start do
  add_filter(/^\/spec\//) # For RSpec, use `test` for MiniTest
end

Coveralls.wear! if ENV['TRAVIS']

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end

require 'puts_debuggerer'
require 'strategic'
