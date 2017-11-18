# -*- encoding: utf-8 -*-
# stub: mail-gpg 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mail-gpg".freeze
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Kraemer".freeze]
  s.date = "2017-04-13"
  s.description = "GPG/MIME encryption plugin for the Ruby Mail Library\nThis tiny gem adds GPG capabilities to Mail::Message and ActionMailer::Base. Because privacy matters.".freeze
  s.email = ["jk@jkraemer.net".freeze]
  s.homepage = "https://github.com/jkraemer/mail-gpg".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "GPG/MIME encryption plugin for the Ruby Mail Library".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mail>.freeze, [">= 2.5.3", "~> 2.5"])
      s.add_runtime_dependency(%q<gpgme>.freeze, [">= 2.0.2", "~> 2.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<actionmailer>.freeze, [">= 3.2.0"])
      s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda-context>.freeze, ["~> 1.1"])
    else
      s.add_dependency(%q<mail>.freeze, [">= 2.5.3", "~> 2.5"])
      s.add_dependency(%q<gpgme>.freeze, [">= 2.0.2", "~> 2.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<actionmailer>.freeze, [">= 3.2.0"])
      s.add_dependency(%q<byebug>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda-context>.freeze, ["~> 1.1"])
    end
  else
    s.add_dependency(%q<mail>.freeze, [">= 2.5.3", "~> 2.5"])
    s.add_dependency(%q<gpgme>.freeze, [">= 2.0.2", "~> 2.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<actionmailer>.freeze, [">= 3.2.0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda-context>.freeze, ["~> 1.1"])
  end
end
