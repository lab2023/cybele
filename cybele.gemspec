# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/cybele/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'cybele'
  spec.version       = Cybele::VERSION
  spec.authors       = %w[lab2023]
  spec.email         = %w[info@lab2023.com]
  spec.description   = %q{Yet another rails template gem}
  spec.summary       = %q{Yet another rails template gem}
  spec.homepage      = 'https://github.com/lab2023/cybele'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'bundler', '~> 1.3'
  spec.add_dependency 'rails', '~> 4.0.0.rc1'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = %w[cybele]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.extra_rdoc_files = %w[README.md LICENSE.txt]
end
