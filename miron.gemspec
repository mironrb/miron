# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miron/version'

Gem::Specification.new do |spec|
  spec.name          = 'miron'
  spec.version       = Miron::VERSION
  spec.authors       = 'Jon Moss'
  spec.email         = 'me@jonathanmoss.me'

  spec.summary       = 'A redesigned Ruby web interface.'
  spec.description   = 'A redesigned Ruby web interface.'
  spec.homepage      = 'https://github.com/mironrb/miron'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'claide'
  spec.add_runtime_dependency 'multi_json'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'httparty'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'yard'
end
