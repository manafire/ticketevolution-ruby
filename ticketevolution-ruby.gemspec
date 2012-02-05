# -*- encoding: utf-8 -*-
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'ticket_evolution', 'version')

Gem::Specification.new do |s|
  s.name        = 'ticketevolution-ruby'
  s.version     = TicketEvolution::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['David Malin', 'Ticket Evolution']
  s.email       = ['dev@ticketevolution.com']
  s.homepage    = 'http://api.ticketevolution.com'
  s.summary     = 'Integration gem for Ticket Evolution\'s api'
  s.description = ''

  s.required_rubygems_version = '>= 1.3.5'

  s.add_dependency 'activesupport'
  s.add_dependency 'i18n'
  s.add_dependency 'curb'
  s.add_dependency 'yajl-ruby'
  s.add_dependency 'multi_json'

  s.add_development_dependency 'rspec', '>= 2.7.1'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
