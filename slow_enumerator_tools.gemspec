# frozen_string_literal: true

require_relative 'lib/slow_enumerator_tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'slow_enumerator_tools'
  spec.version       = SlowEnumeratorTools::VERSION
  spec.authors       = ['Denis Defreyne']
  spec.email         = ['denis.defreyne@stoneship.org']

  spec.summary       = 'provides tools for transforming Ruby enumerators that produce data slowly and unpredictably'
  spec.homepage      = 'https://github.com/ddfreyne/slow_enumerator_tools'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
end
