# -*- encoding: utf-8 -*-
# stub: brakeman 4.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "brakeman".freeze
  s.version = "4.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Justin Collins".freeze]
  s.cert_chain = ["brakeman-public_cert.pem".freeze]
  s.date = "2017-09-25"
  s.description = "Brakeman detects security vulnerabilities in Ruby on Rails applications via static analysis.".freeze
  s.email = "gem@brakeman.org".freeze
  s.executables = ["brakeman".freeze]
  s.files = ["bin/brakeman".freeze]
  s.homepage = "http://brakemanscanner.org".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "Brakeman 4.0 has important changes that may affect you. Please see our blog post for details: https://brakemanscanner.org/blog/2017/09/25/brakeman-4-dot-0-released/".freeze
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Security vulnerability scanner for Ruby on Rails.".freeze

  s.installed_by_version = "2.7.2" if s.respond_to? :installed_by_version
end
