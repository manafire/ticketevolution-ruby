require 'curb'
require File.join(File.dirname(File.expand_path(__FILE__)), "..", "extensions", "kernel")
require 'ticketevolution/base'

module Ticketevolution
  extend self
  version = "0.1"
  mattr_accessor :token, :secret, :version

  class ConfigurationMissing < Exception; end

  
  
  def configure(&block)
    instance_eval(&block)
  end
end