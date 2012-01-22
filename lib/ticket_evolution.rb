require 'rubygems'
require 'multi_json'
require 'curb'

require 'base64'
require 'digest/md5'
require 'openssl'
require 'pathname'
require 'cgi'
require 'uri'

require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/class'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object/to_param'
require 'active_support/core_ext/object/to_query'

module TicketEvolution
  mattr_reader :root

  @@root = Pathname.new(File.dirname(File.expand_path(__FILE__))) + 'ticket_evolution'
end

def irequire(*parts); require TicketEvolution.root + File.join(parts); end

irequire 'version.rb' unless defined?(TicketEvolution::VERSION)
irequire 'connection.rb'
irequire 'errors', 'invalid_configuration.rb'

