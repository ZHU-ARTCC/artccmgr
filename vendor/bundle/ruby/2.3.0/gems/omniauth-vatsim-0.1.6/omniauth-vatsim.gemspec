# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-vatsim/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-vatsim"
  spec.version       = Omniauth::Vatsim::VERSION
  spec.authors       = ["Jonathan P. Voss"]
  spec.email         = ["jvoss@onvox.net"]

  spec.summary       = %q{OmniAuth strategy for VATSIM OAuth/SSO}
  spec.description   = %q{OmniAuth strategy for VATSIM OAuth/SSO}
  spec.homepage      = "https://github.com/jvoss/omniauth-vatsim"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'multi_json', '~> 1.3'
  spec.add_runtime_dependency 'omniauth-oauth', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
