# -*- encoding: utf-8 -*-
# stub: m9t 0.3.6 ruby lib

Gem::Specification.new do |s|
  s.name = "m9t".freeze
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Joe Yates".freeze]
  s.date = "2016-04-05"
  s.description = "Classes for handling basic measurement units: distance, direction, speed, temperature and pressure".freeze
  s.email = "joe.g.yates@gmail.com".freeze
  s.homepage = "https://github.com/joeyates/m9t".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubyforge_project = "nowarning".freeze
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Measurements and conversions library for Ruby".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<i18n>.freeze, [">= 0.3.5"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 0.4.8"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 3.0.0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<i18n>.freeze, [">= 0.3.5"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 0.4.8"])
      s.add_dependency(%q<rspec>.freeze, [">= 3.0.0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<i18n>.freeze, [">= 0.3.5"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 0.4.8"])
    s.add_dependency(%q<rspec>.freeze, [">= 3.0.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end
