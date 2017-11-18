# -*- encoding: utf-8 -*-
# stub: bootstrap-multiselect_rails 0.9.5 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-multiselect_rails".freeze
  s.version = "0.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Trevor Strieber".freeze]
  s.date = "2014-07-07"
  s.description = "This gem packages the Bootstrap multiselect (JS & CSS) for Rails 3.1+ asset pipeline.".freeze
  s.email = ["trevor@strieber.org".freeze]
  s.homepage = "http://github.com/TrevorS/bootstrap-multiselect_rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Bootstrap 2/3 multiselect's JS & CSS for Rails 3.1+ asset pipeline.".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
