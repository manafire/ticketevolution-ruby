require File.join(File.dirname(File.expand_path(__FILE__)), "..", "extensions", "kernel")
require 'curb'
require 'json'
require 'ticketevolution/base'
require 'ticketevolution/category'
require 'ticketevolution/performer'
require 'ticketevolution/venue'
require 'ticketevolution/event'



module Ticketevolution
  extend self
  version = "0.1"
  mattr_accessor :token, :secret, :version, :mode

  class InvalidConfiguration < Exception; end


  def configure(&block)
    instance_eval(&block)
  end
end