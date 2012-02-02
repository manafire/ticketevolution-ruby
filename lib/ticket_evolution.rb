require 'rubygems'
require 'yajl'
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
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_param'
require 'active_support/core_ext/object/to_query'
require 'active_support/inflector'

module TicketEvolution
  mattr_reader :root

  @@root = Pathname.new(File.dirname(File.expand_path(__FILE__))) + 'ticket_evolution'
end

c = Module.new { def self.req(*parts); require TicketEvolution.root + 'core' + File.join(parts); end }
i = Module.new { def self.req(*parts); require TicketEvolution.root + File.join(parts); end }
m = Module.new { def self.req(*parts); require TicketEvolution.root + 'modules' + File.join(parts); end }

i.req 'version.rb' unless defined?(TicketEvolution::VERSION)

# Core modules
c.req 'singular_class.rb'

# Core classes
c.req 'api_error.rb'
c.req 'base.rb'
c.req 'builder.rb'
c.req 'collection.rb'
c.req 'connection.rb'
c.req 'datum.rb'
c.req 'endpoint', 'request_handler.rb'
c.req 'endpoint.rb'
c.req 'model.rb'
c.req 'time.rb'

# Sample classes for test support
c.req 'models', 'samples.rb'
c.req 'samples.rb'

# Errors
i.req 'errors', 'connection_not_found.rb'
i.req 'errors', 'endpoint_configuration_error.rb'
i.req 'errors', 'invalid_configuration.rb'
i.req 'errors', 'method_unavailable_error.rb'

# Endpoint modules
m.req 'create.rb'
m.req 'deleted.rb'
m.req 'list.rb'
m.req 'search.rb'
m.req 'show.rb'
m.req 'update.rb'

# Builder Classes
i.req 'account.rb'
i.req 'address.rb'
i.req 'brokerage.rb'
i.req 'category.rb'
i.req 'client.rb'
i.req 'configuration.rb'
i.req 'credit_card.rb'
i.req 'email_address.rb'
i.req 'event.rb'
i.req 'office.rb'
i.req 'performer.rb'
i.req 'phone_number.rb'
i.req 'quote.rb'
i.req 'shipment.rb'
i.req 'ticket_group.rb'
i.req 'user.rb'
i.req 'venue.rb'

# Endpoint Classes
i.req 'accounts.rb'
i.req 'brokerages.rb'
i.req 'categories.rb'
i.req 'clients.rb'
i.req 'configurations.rb'
i.req 'events.rb'
i.req 'offices.rb'
i.req 'performers.rb'
i.req 'quotes.rb'
i.req 'shipments.rb'
i.req 'ticket_groups.rb'
i.req 'users.rb'
i.req 'venues.rb'
i.req 'search.rb'

i.req 'clients', 'addresses.rb'
i.req 'clients', 'credit_cards.rb'
i.req 'clients', 'email_addresses.rb'
i.req 'clients', 'phone_numbers.rb'
i.req 'configurations', 'venues.rb'
i.req 'offices', 'brokerages.rb'
i.req 'users', 'offices.rb'
