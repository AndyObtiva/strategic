# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: strategic 0.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "strategic".freeze
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andy Maleh".freeze]
  s.date = "2020-01-27"
  s.description = "if/case conditionals can get really hairy in highly sophisticated business domains.\nDomain model inheritance can help remedy the problem, but you don't want to dump all\nlogic variations in the same domain models.\nStrategy Pattern solves that problem by externalizing logic variations to\nseparate classes outside the domain models.\nOne difficulty with implementing Strategy Pattern is making domain models aware\nof newly added strategies without touching their code (Open/Closed Principle).\nStrategic solves that problem by supporting Strategy Pattern with automatic discovery\nof strategies and ability fetch the right strategy without conditionals.\nThis allows you to make any domain model \"strategic\" by simply following a convention\nin the directory/namespace structure you create your strategies under so that the domain\nmodel automatically discovers all available strategies.\n".freeze
  s.email = "andy.am@gmail.com".freeze
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "lib/strategic.rb"
  ]
  s.homepage = "http://github.com/AndyObtiva/strategic".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Painless Strategy Pattern for Ruby and Rails".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_development_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.3.0"])
      s.add_development_dependency(%q<coveralls>.freeze, ["= 0.8.5"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.10.0"])
      s.add_development_dependency(%q<puts_debuggerer>.freeze, ["~> 0.8.0"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.0"])
      s.add_dependency(%q<coveralls>.freeze, ["= 0.8.5"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.10.0"])
      s.add_dependency(%q<puts_debuggerer>.freeze, ["~> 0.8.0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.0"])
    s.add_dependency(%q<coveralls>.freeze, ["= 0.8.5"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.10.0"])
    s.add_dependency(%q<puts_debuggerer>.freeze, ["~> 0.8.0"])
  end
end

