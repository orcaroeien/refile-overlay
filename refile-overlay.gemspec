# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'refile/overlay/version'

Gem::Specification.new do |spec|
  spec.name          = 'refile-overlay'
  spec.version       = Refile::Overlay::VERSION
  spec.authors       = ['Laurens Post']
  spec.email         = ['webmaster@orcaroeien.nl']
  spec.summary       = %q{UnionFS-like overlay for Refile backends}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `find -type f -printf "%P\n"`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'refile'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock'
end
