# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thinking_sphinx/hunspell/version'

Gem::Specification.new do |spec|
  spec.name           = 'thinking-sphinx-hunspell'
  spec.version        = ThinkingSphinx::Hunspell::VERSION
  spec.authors        = ['Joseph Glanville']
  spec.email          = 'jpg@jpg.id.au'
  spec.summary        = 'An add-on gem for spelling suggestions in Thinking Sphinx'
  spec.description    = 'Adds spelling suggestions to Thinking Sphinx searches.'
  spec.homepage       = 'http://github.com/josephglanville/thinking-sphinx-hunspell'

  spec.license        = 'MIT'
  spec.files          = `git ls-files -z`.split("\x0")
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ['lib']

  spec.add_runtime_dependency 'ffi-hunspell', '>= 0.3.0'
  spec.add_runtime_dependency 'thinking-sphinx', '>= 1.2.12'
end
