# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'kantox_checkout_app'
  s.version     = '0.1.0'
  s.summary     = 'Supermarket checkout with robust API and rule engine'
  s.description = 'Pure Ruby checkout with composable pricing rules and CLI'
  s.authors     = ['Igor Cubric']
  s.email       = ['cubricigor@gmail.com']
  s.files       = Dir['lib/**/*', 'README.md', 'LICENSE']
  s.homepage    = 'https://github.com/igorcubric/kantox_checkout_app'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2.0'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
end
