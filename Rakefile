# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "strategic"
  gem.homepage = "http://github.com/AndyObtiva/strategic"
  gem.license = "MIT"
  gem.summary = %Q{Painless Strategy Pattern for Ruby and Rails}
  gem.description = <<-MULTI
if/case conditionals can get really hairy in highly sophisticated business domains.
Domain model inheritance can help remedy the problem, but you don't want to dump all
logic variations in the same domain models.
Strategy Pattern solves that problem by externalizing logic variations to
separate classes outside the domain models.
One difficulty with implementing Strategy Pattern is making domain models aware
of newly added strategies without touching their code (Open/Closed Principle).
Strategic solves that problem by supporting Strategy Pattern with automatic discovery
of strategies and ability fetch the right strategy without conditionals.
This allows you to make any domain model "strategic" by simply following a convention
in the directory/namespace structure you create your strategies under so that the domain
model automatically discovers all available strategies.
  MULTI
  gem.email = "andy.am@gmail.com"
  gem.authors = ["Andy Maleh"]
  gem.files = Dir['lib/**/*.rb']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "strategic #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :spec_with_coveralls => [:spec] do
  ENV['TRAVIS'] = 'true'
  ENV['CI'] = 'true' if ENV['CI'].nil?
  Rake::Task['coveralls:push'].invoke
end
