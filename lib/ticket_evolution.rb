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
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_param'
require 'active_support/core_ext/object/to_query'
require 'active_support/inflector'

module TicketEvolution
  mattr_reader :root

  @@root = Pathname.new(File.dirname(File.expand_path(__FILE__))) + 'ticket_evolution'
end

def irequire(*parts); require TicketEvolution.root + File.join(parts); end

irequire 'version.rb' unless defined?(TicketEvolution::VERSION)

# Core modules
irequire 'modules', 'create.rb'
irequire 'modules', 'deleted.rb'
irequire 'modules', 'list.rb'
irequire 'modules', 'search.rb'
irequire 'modules', 'show.rb'
irequire 'modules', 'update.rb'

# Core classes
irequire 'base.rb'
irequire 'connection.rb'
irequire 'endpoint.rb'
irequire 'sample.rb'

# Errors
irequire 'errors', 'endpoint_configuration_error.rb'
irequire 'errors', 'invalid_configuration.rb'
irequire 'errors', 'method_unavailable_error.rb'

# Endpoint Classes
irequire 'brokerage.rb'
irequire 'category.rb'
irequire 'client.rb'
irequire 'event.rb'
irequire 'office.rb'
irequire 'user.rb'
