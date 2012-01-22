require 'base64'
require 'digest/md5'
require 'openssl'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'ticket_evolution.rb')

RSpec.configure do |config|
end

require File.join(File.dirname(File.expand_path(__FILE__)), 'shared_examples.rb')
