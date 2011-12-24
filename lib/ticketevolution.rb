require 'curb'
require File.join(File.dirname(File.expand_path(__FILE__)), "..", "extensions", "kernel")

module Ticketevolution
  extend self
  mattr :token, :secret, :version

  def self.configure(&block)
    instance_eval(&block)
  end
  

  
  	
end