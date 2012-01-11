require 'curb'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string/inflections'
Dir.glob(File.join(File.dirname(__FILE__),".." ,"extensions/*.rb")).sort.each { |f| require f }
Dir.glob(File.join(File.dirname(__FILE__),"..", "lib" ,"ticket_evolution","helpers/*.rb")).sort.each { |f| require f }
Dir.glob(File.join(File.dirname(__FILE__),"..", "lib" ,"ticket_evolution/*.rb")).sort.each { |f| require f }

# Note the load pattern is important as the helpers need to be instantiated before
# the acutal classes. The extensions are jsut additions so there will be no missing constants
# but in interest of organization its second

module TicketEvolution
  extend self
  include Helpers::Http

  version = "0.1"
  mattr_accessor :token, :secret, :version, :mode, :protocol

  class InvalidConfiguration < Exception; end
  class EmptyResourceError < Exception;   end

  def configure(&block)
    instance_eval(&block)
  end
end
