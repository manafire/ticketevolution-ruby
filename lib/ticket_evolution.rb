require 'rubygems'
require 'multi_json'
require 'curb'

require 'ostruct'
require 'base64'
require 'digest/md5'
require 'openssl'
require 'pathname'
require 'cgi'
require 'uri'

require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/class'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_param'
require 'active_support/core_ext/object/to_query'
require 'active_support/inflector'

module TicketEvolution
  mattr_reader :root

  @@root = Pathname.new(File.dirname(File.expand_path(__FILE__))) + 'ticket_evolution'
end

def crequire(*parts); require TicketEvolution.root + 'core' + File.join(parts); end
def irequire(*parts); require TicketEvolution.root + File.join(parts); end
def mrequire(*parts); require TicketEvolution.root + 'modules' + File.join(parts); end

irequire 'version.rb' unless defined?(TicketEvolution::VERSION)

# Core classes
crequire 'api_error.rb'
crequire 'base.rb'
crequire 'builder.rb'
crequire 'connection.rb'
crequire 'datum.rb'
crequire 'endpoint', 'request_handler.rb'
crequire 'endpoint.rb'
crequire 'samples.rb'
crequire 'time.rb'

# Errors
irequire 'errors', 'endpoint_configuration_error.rb'
irequire 'errors', 'invalid_configuration.rb'
irequire 'errors', 'method_unavailable_error.rb'

# Endpoint modules
mrequire 'create.rb'
mrequire 'deleted.rb'
mrequire 'list.rb'
mrequire 'search.rb'
mrequire 'show.rb'
mrequire 'update.rb'

# Endpoint Classes
irequire 'brokerages.rb'
irequire 'categories.rb'
irequire 'clients.rb'
irequire 'events.rb'
irequire 'offices.rb'
irequire 'users.rb'

# Builder Classes
irequire 'brokerage.rb'
irequire 'category.rb'
irequire 'client.rb'
irequire 'event.rb'
irequire 'office.rb'
irequire 'user.rb'
